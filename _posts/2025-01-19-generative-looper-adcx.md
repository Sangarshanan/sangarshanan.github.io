---
layout: post
title: "Deluloop: A generative looper for Music Hack day'25"
comments: false
tags:
    - music-tech
---

My first talk of 2025 was at [ADCx India](https://audio.dev/adcx-india-25/). I gave a small workshop on the Music Hack day about using Ableton with Python to send MIDI signals through an IAC bus channel. I was able to send generative beats and tunes made in Python to be played on Ableton.

After the workshop, I caught up with friends and we decided to work on a hack of our own. Our idea was to use a generative model like [Jasco](https://huggingface.co/facebook/jasco-chords-drums-melody-1B) to take input from a microphone or uploaded audio, plus a text prompt, to generate compositions that could be played and tinkered with in real-time! This could act as a performance tool that is natively a generative looper. One could control the scale and tempo to make sure that generations are conducive to jamming with.

We built it using Streamlit, set up a GPU server on Jarvislabs, and demoed it as a performance tool the next day!

<iframe src="https://drive.google.com/file/d/19ZUuHIMaOiaToT_uqX5C51Zemq5u_cqO/preview" width="700" height="480" allow="autoplay"></iframe>

Repo: <https://github.com/Sangarshanan/deluloop>