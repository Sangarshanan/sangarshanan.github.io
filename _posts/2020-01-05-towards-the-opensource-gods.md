---
layout: post
title: "Towards the Open Source gods"
comments: false
description: FOSS 
keywords: "FOSS"
tags:
    - open source
---


When I was in college I wanted to work on everything I considered to be cool, I didn't spend time learning and just started jumping into projects half assed and just worked on it enough to make it work. I wrote shit code that just worked, Totally unreadable, Silly shortcuts, embarrassing mistakes and man should I even start about reproducibility. One of my projects used to only work on a full moon from 12 - 2AM when the demons could hear compilation   

I'm not in college anymore and more recently I've started writing code that is going into production and is critical so I can't afford to write code that "just works". It's also high time I learn to write code I can shed happy tears about. I figured the best way to do that is to start my pilgrimage towards to open source gods. Looking at some of the code written on amazing open source projects opened a million doors 

So I am going to track my Open source Journey here, 


### YellowBrick

My very first Open source contribution was made by following the big Gsoc hype. I thought that contributing can lead way to Gsoc which never happened and I kinda lost track being lazy :( I had never used yellowbrick before but it turned to be quite useful so I decided to contribute a simple example (That was my NLP Phase)

<https://github.com/DistrictDataLabs/yellowbrick#yellowbrick-datasets>

Was kinda scared at first but the maintainers were really appreciative and amazing that I ended up writing a blog about it too <https://www.districtdatalabs.com/rapid-text-visualization-with-yellowbrick>


### PyPa Packaging

Ok so this was pretty big for me since I felt confident enough to move from contributing documentation to actual code, well github action but still counts  

<https://github.com/pypa/packaging/pull/243>

It felt amazing to contribute to pypa cause I fanboy over Brett Cannon (https://snarky.ca/ ) and Dustin Ingram (The million amazing Pycon talks) 

### Geopandas

I am actually still looking to contribute more to geopandas cause it's an amazing package and I use it almost regularly at work. 

Documentation <https://github.com/geopandas/geopandas/pull/1228>
Issue <https://github.com/geopandas/geopandas/issues/595#issuecomment-569616474>

Also to_postgis has potential to postgres flavored, this couldn't be done in pandas <https://github.com/geopandas/geopandas/issues/1174>

Added Changelog to docs

<https://github.com/geopandas/geopandas/pull/1306>

Creating a geodataframe out of a datframe modified the original dataframe, so I created a copy of the dataframe before it was modified, this is actually my first actual code contribution to geopandas:)

<https://github.com/geopandas/geopandas/pull/1324>

### Pandas 

Moved to fstrings, This was a pretty low hanging fruit
<https://github.com/pandas-dev/pandas/pull/30700>

### Broadcaster

Not really gonna count this but documenting it anyway, fixed a broken link <https://github.com/encode/broadcaster/pull/12>

### Apache Airflow 

This was exciting, airflow is a workflow orchestrator that I have been using at work for quite some time now  and it was exciting to contribute a feature, the PR will enable filtering of dags by clicking on the tags

<https://github.com/apache/airflow/pull/8897>