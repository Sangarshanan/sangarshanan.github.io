---
layout: post
title: "Jupyter and its 79 Dashboards"
comments: false
keywords: "oss"
tags:
    - RC
---

The real Jupiter and 79 moons but Jupyter had "oh so lot" of tools for building dashboards. Granted most of em are Python dashboarding tools and not actually based off notebooks yet there are extensions to tie them to the Jupyter ecosystem

Jupyter notebooks are amazing for quickly hacking out cool nifty code that does a bunch of stuff but exposing what we built to someone who is not "techy" is a little hard so jupyter has this whole ecosystem of tools to convert notebooks into dashboards like [voila](https://github.com/voila-dashboards/voila), there are also other nice tools like [streamlit](https://www.streamlit.io/), [Dash](https://github.com/plotly/dash), [Bokeh](https://github.com/bokeh/bokeh/) that can be used to quickly hack out really awesome interface with minimal coding

I though would be was nice to have a way to expose all these dashboards that people build directly on Jupyterhub which in itself already offers you an auth layer and a layer to spin up servers and services. I though something that can help expose all the different dashboarding tools to non-tech users using the Jupyterhub would make it really easy to expose and consume information

Related issues <https://github.com/voila-dashboards/voila/issues/112> <https://github.com/streamlit/streamlit/issues/927>
