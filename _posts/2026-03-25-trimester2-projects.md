---
layout: post
title: "Tales & Projects from the Second Trimester"
comments: false
keywords: "Learn"
tags:
    - music-tech
---

The second trimester is officially over! This was a big one with all the major classes, Doing assignments with deadlines and writing papers was a bit hectic but also fun so I am gonna miss it. From now on, the course will shift more towards finding an appropriate idea for my thesis and to work on it. I have an internship coming up in May and tbf there are so many uncertainties about a lot of things which makes me quite anxious cause it's no longer about the classes, but I do know that i want to speed run all the ideas that came up during my course and continue to build and learn things.

I made a set recently for livecode blr and even though I like the output, I feel like it could be better and I really believe there is a skill gap that I would definitely like to bridge and start discovering my edge in music. its not about the performance, its something deeply personal. Art always is, I guess?

Well, anyway, that was a tangent, here are the projects I worked on this trimester.

### Infinite Lofi Generator

This project is a collection of Python functions to generatively create Lofi music using MIDI (drums, chords and melody) and sends it across to ableton to Sonify them. The generative models used are intentionally old school, like L-Systems and Hidden Markov Models. cause I wanted to understand, improve and iterate on the models faster. Also i am in perpetual state of GPU poor.

This was fun cause I was able to record interesting sections and make weird poly rhythmic beats, it acts more like a sampling tool for me rather than an AI music generator.

<div style="text-align:center; margin: 2em 0;">
    <iframe 
        width="560" 
        height="315" 
        src="https://www.youtube.com/embed/oURdZkIgkYM" 
        title="YouTube video player" 
        frameborder="0" 
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
        allowfullscreen>
    </iframe>
</div>
### Windowed Latent Granular Resynthesis with Encodec

Training models is overrated, It is hella fun to manipulate audio without getting into the whole deal of training a big ass model! For our generative music class we were asked to explore Latent spaces of Neural Audio codecs and see what we can get out of them.

This [paper](https://naotokui.net/research/paper-latent-granular-resynthesis/) by the folks at Neutone explores a cool technique for creative audio resynthesis by creating a “granular codebook” that encoded the source audio corpus into latent vector segments, then matches each latent grain of a target audio signal to its closest counterpart in the codebook. The resulting hybrid sequence is decoded to produce audio that preserves the target’s temporal structure while adopting the source’s timbral characteristics.

The original paper works with music2latent but reworking this with Encodec would be interesting because Music2Latent is built for efficient generative modelling applications and for other downstream tasks whereas Encodec is for Neural Audio Compression. What this means is that the latent space is more entangled i.e., makes less sense but the resynthesis is sped up allowing for realtime streaming.

I worked on this for my project and wrote a short report along with website that has audio samples!

- Here is my code: <https://github.com/Sangarshanan/latent-granular-resynthesis>
- Audio examples: <https://latent-granular-resynthesis.vercel.app/>
- Link to the original Implementation: <https://huggingface.co/spaces/naotokui/latentgranular/blob/main/app.py>


### Ornamentation classification in Hindustani vocal music

This project started as a way to transcribe Bansuri music cause we have so many open audio recordings and I quickly realized I was too ambitious so we started with ornamentation detection and classification which is a prior for transcription! Me and my uber cool team worked on detection and classification of ornamentations by extending the work of Jain & Arthur (2023) (DLfM). Our project combined their rule-based approach with a density-driven adaptive windowing strategy that adjusts temporal resolution based on local melodic activity. We also evaluated deep learning models like the Temporal Convolutional Network (TCN) with different pooling strategies.

Our project is on Github: <https://github.com/Sangarshanan/hindustani-ornamentation-classification>

We plan to build on top of this by including more features such as timbre and loudness, since ornamentations are not distinguished solely by their pitch curves. It would be nice to publish this work!

### Measuring similarity between Makams & Ragas

So, this project basically compares two deep Eastern music traditions: Hindustani Ragas and Ottoman-Turkish Makams. Both of these share a similar approach to melody using massive systems of different modes and rules, so we fed some symbolic MusicXML datasets into the MelodyShape similarity framework to see how they stack up. We used ShapeH and Time metrics to analyze the melodic structure of everything from full compositions down to tiny little melodic fragments.

We ended up focusing on three specific Hindustani Ragas and ran them against a corpus of Turkish Makams. The results were pretty cool, and Raga Bhairav consistently spit out strong matches with several Turkish Makams, basically proving the old music theory claims about their shared intervals with actual computational data.

This was really fun cause it gave hard evidence for how these modal traditions connect, but it also definitely highlighted that working with purely symbolic data has its limits when you're trying to capture the full, rich vibe of these complex musical systems.

Our project with the slides, report and code (obv): <https://github.com/Sangarshanan/makam-and-ragas>


### So what bro

Coming from engineering, this was my first time following traditional research approaches to problem statements, going from first principles, implementing papers, working on top of them, making potential improvements and also writing ISMIR type papers. A taste of academia :) A nice lil prep for my thesis (whatever that is gonna end up being)
