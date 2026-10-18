---
layout: post
title: "SpectralOli: I made a Livecoding tool"
comments: false
keywords: "Learn"
tags:
    - music-tech
---

As a student of sound, Spectrograms have become a very good friend, A bit daunting at first but slowly it has warmed up to me and transforms into a painting of the sound, slowly whispering secrets even before the audio reaches my ears. Tools like Metasynth really embody this philosophy by letting you treat them as canvases to draw on.

Freesound also known to us as MTG's crown jewel, houses several creative commons loops and a nifty api for accessing it. With help from [Gerard Roma](https://g-roma.github.io/) I embarked upon the task of building a livecoding tool to play around with freesound loops and at the same time borrowing from "spectrogram as a canvas" philosophy.

You can access it here: <https://spectral-oli.vercel.app/>

<iframe width="560" height="315" src="https://www.youtube.com/embed/_ybAQgm06G4?si=bOYKOBIUv-PH4WPx" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

There is a custom DSL written to edit the spectrogram and it was quite interesting and fun to look at and play around the different trade offs that are bound to show up when writing such a thing especially for an esoteric live coding tool running on the browser. Finally, I ended up with a four layer DSL helping modify aspects of global directives (clock, band size etc), time slicing, frequency masking and at last some special esoteric spectral transformation, these are in my opinion the most fun because we can do operations like rotating the spectrogram or transposing across the time, frequency axis.

Well, This is definitely only the first version of the tool and I am kinda excited to build on this further, there are still lingering questions about performance, How would one choose the loops they want to modify, can we take advantage of audio features on Freesound? Can we use another dimension outside of a spectrogram or a waveform to edit the sound? maybe latent transformations? How does this tool translate to different livecoding contexts and exploring its limitations in different contexts! I am talking to people about this and working on a few of these ideas in parallel, I will add more notes as some of these ideas develop.


