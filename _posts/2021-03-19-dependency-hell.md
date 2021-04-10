---
layout: post
title: "To Dependency hell and back with Python"
comments: false
description: 
tags:
    - bugs
---

Python is mostly awesome but sometimes it gives me splitting migraines and one of those scenarios is when I get sucked into a rabbit hole of debugging and utter confusion only to discover that a dependency of another dependency has changed it's API a wee bit

The first time it happened was with `pandas` where a not so directly used sub-dependency `numpy` is not pinned <https://github.com/pandas-dev/pandas/blob/00a622401e06bd7afaaa508707a46f3dcc494fe4/setup.cfg#L34> and so installing pandas upgrades numpy and broke a bunch of stuff in staging servers while working perfectly fine locally cause `numpy` was already installed in my environment. I had to test with `docker-compose` after wiping every single cache in existence

The second time around an API that writes a dataframe to postgres started failing with the error log

`ImportError: cannot import name 'RowProxy' from 'sqlalchemy.engine'`

This was because `SQLAlchemy==1.4.4` was updated/installed by a sub dependency 😞 so just downgrading SQLAlchemy to `SQLAlchemy==1.3.20` solved the whole thing, I initially started going around stripping brackets `(` before wondering how it worked for me locally and checking out the versions

Now this happened the third time today but thankfully I caught it in like 5 mins cause I have started expecting this from Python every time I am hit with the old **But it works on my machine and not on the server !**

I have a utility function that calculates the area of a polygon populating several data sinks in the system and people use it for analysis and also data science stuff

It is a very simple function that Reprojects the polygon and returns the area in Sq Kms

```python
import pyproj
import shapely.ops as ops
import geopandas as gpd
from functools import partial
from shapely.geometry import Polygon

world = gpd.read_file(
    gpd.datasets.get_path('naturalearth_lowres')
)
polygon = world['geometry'][1]

def polygon_area(geom):
    """Polygon area."""
    geom_area = ops.transform(
        partial(
            pyproj.transform,
            pyproj.Proj("EPSG:4326"),
            pyproj.Proj(
                proj="aea", 
                lat_1=geom.bounds[1], 
                lat_2=geom.bounds[3]
            ),
        ),
        geom,
    )
    # Get the area in km^2
    return geom_area.area / 1000000

polygon_area(polygon)
```

Returns `773852` sq km which was **very very wrong** and people doing the analysis and running data science experiments with this data were quick to spot this

Now this fixed function is the one below

```python
def polygon_area(geom):
    """Polygon area."""
    geom_area = ops.transform(
        partial(
            pyproj.transform,
            pyproj.Proj(init="EPSG:4326"),
            pyproj.Proj(proj="aea", lat_1=geom.bounds[1], lat_2=geom.bounds[3]),
        ),
        geom,
    )
    # Get the area in km^2
    return geom_area.area / 1000000
polygon_area(polygon)
```

This rightly returns `932590` sq km as the area

For reference I use `geopandas==0.7.0` and pyproj is a sub dependency so it gets automatically upgraded by geopandas, in my environment it was `pyproj==2.5.0`

I just added an `init=` to the initialization of the projection

![Ham](/img/in-post/shapely-polygons.png)

Without the `init` argument specified the defaults turn to something else and the polygons end up being wildly different as you can see from the above notebook.

You blink and you miss, that is how dumb the fix was, just an `init` param but the usage of `init` parameter in the above function actually returned a `Future warning` and also linked to https://pyproj4.github.io/pyproj/stable/gotchas.html#axis-order-changes-in-proj-6 saying it was going to be deprecated, so looks like I should use CRS rather than Proj here

Note: Poetry manages these sub-dependencies pretty well and creates a `.lock` file to pin the working environment, it has been a lifesaver.
