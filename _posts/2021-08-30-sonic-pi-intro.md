---
layout: post
title: "Yoo Sonic Pi slaps !!"
description:  
keywords: "music"
header-style: text
tags:
    - music
    - nerd
---

![](https://rbnrpi.files.wordpress.com/2015/01/sonic-pi-web-logo.png)

I found Sonic Pi on [Hackernews](https://news.ycombinator.com/item?id=28274069) and by just seeing the words music and code in the same sentence I was sold. The project is dubbed as a **new kind musical instrument**

>  **Instead of strumming strings or whacking things with sticks - you write code - live.**

I was so down to install and play around with it before I read the [dreadful words](https://github.com/sonic-pi-net/sonic-pi/blob/main/BUILD-LINUX.md)

> Note: Sonic Pi for Linux isn't currently officially supported and we can't guarantee that it will work on all variants of Linux on all hardware. However, we provide these instructions in the hope that they can help you get Sonic Pi running on your specific Linux distribution.

![](https://i.kym-cdn.com/entries/icons/facebook/000/024/196/sign.jpg)

I was able to clone and build it cleanly but when I tried to boot it up it crashed and hit me with bunch of logs, I looked around the interweb forums <https://discourse.ardour.org/t/cannot-start-jack-as-regular-user/83468/8> & <https://github.com/sonic-pi-net/sonic-pi/issues/1873> but nothing worked

Then I found <https://in-thread.sonic-pi.net/t/install-sonic-pi-3-3-beta-on-ubuntu-20-04-very-easy/4406>

Rather than building the latest version from source I decided to try the old fashion `apt-get` and installed the version 2.2 of Sonic pi using `sudo apt-get install sonic-pi`

This worked 🤘 !!!!

But a disclaimer, once I booted up Sonic pi I noticed that it took over my audio output and no other application could produce sound, which meant I could not watch youtube videos or listen to music while sonic-pi was open 😿 Need to check and fix this but for now I live with it.

The language is so simple that it is easy for anyone to get started but powerful enough to support sophisticated sound manipulation and generative music cause its all code. Ruby code to be more precise.

The Tutorial itself is super extensive <https://sonic-pi.net/tutorial.html#section-1> and you can also find amazing resources online like this one <https://sonic-pi.mehackit.org/exercises/en/01-introduction/01-introduction.html> from a creative programming workshop

These resources helped me get started and I made some stupid beats that were a lott of fun to do, it always feels good to see something you write come to life

I put it up on <https://github.com/sangarshanan/sonic-pi-beats>