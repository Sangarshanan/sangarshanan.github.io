---
layout: post
title: "More deets on Geopandas and Interactive maps"
comments: false
keywords: "oss"
tags:
    - open source
---

It is known across the villages that when you wanna work with data and use python you just go with Pandas no doubt about it or atleast something else exposing a very similar API to work with data. It was crazy how groundbreaking this library turned out to be and how it brought so many excel dwellers and code noobs from the caves flocking to the world of Python.

When I joined as an intern at Grofers my first real work had me explore the Geospatial data in the supply chain and how we can leverage it to do some cool data stuff, and it was amazing cause I was the first one to actually do this and GIS was quite untapped at Grofers and I got to the one to open that tap which was more like a Dam. I started by working with QGIS and a while later Geopandas came into the picture, it was like pandas for GIS data and it make my life soo much easier.

But there was a Gap in the ecosystem, with Pandas your plots are quite simple and interactivity can be a "good to have" but with Geopandas and maps interactivity becomes a "must to have" and I had to use other libraries like Folium and Bokeh which exposes very different APIs for interactive mapping and did not offer a seamless integration with GeoDataframes.

I was actually quite pumped about this cause I got myself something to do in the weekends, I hacked up a library called [Geopatra](http://sangarshanan.com/2020/02/20/geopatra/) which worked out quite well for me and since it was working for me I stopped investing more time into making this awesome"er" it is still a ensemble of hacks. I also got to talk about this in detail at [Pycon AU 2020](https://www.youtube.com/watch?v=kmvLn4Iagwo)

But then something awesome happened with Geopandas developer survey

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Help us shape the future of <a href="https://twitter.com/geopandas?ref_src=twsrc%5Etfw">@geopandas</a> development. We&#39;re launching our first GeoPandas User Survey!<a href="https://t.co/05maOC1HT4">https://t.co/05maOC1HT4</a><br><br>It takes 5-10 minutes. After we close it in about a month, we will share the results with you. <br><br>Thank you!</p>&mdash; GeoPandas (@geopandas) <a href="https://twitter.com/geopandas/status/1308375400897277956?ref_src=twsrc%5Etfw">September 22, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Seems tho other hoomans had the same woes as me and wanted to do something about it. The Geopandas community as amazing as it is listened to these hoomans and one of the amazing maintainers [Martin Fleischmann](https://github.com/martinfleis) drafted up an RFC for it over on <https://github.com/martinfleis/geopandas-view/issues/1>

I am super excited to see where this leads 🤞

:wq