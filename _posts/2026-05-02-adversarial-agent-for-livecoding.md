---
layout: post
title: "Livecoding with an Adversarial AI Agent"
comments: false
keywords: "Learn"
tags:
    - music-tech
---

Hey guy

Usually, when people talk about AI agents in music, they’re talking about copilots that finish your sentences and with livecoding maybe they make sure your chords aren't trash? I say that’s boring and so I've been working on a project called *The Code Writes Back* where instead of an agent that helps me, I built an adversarial one that actively tries to ruin my life (and my set) while I'm livecoding.

I'm using [strudel.cc](https://strudel.cc), a web-based livecoding environment. To allow for chaos, I used the Model Context Protocol (MCP) which are honestly just API wrappers with a fancy acronym. This is the setup.

- **The Eyes & Ears:** A multimodal LLM "watches" my code in the browser and "listens" to the audio. My lil chaos instigator.
- **The Hands:** I use Playwright (browser automation) to let the AI literally reach into the text buffer and rewrite code in real-time.
- **The Vibe Check:** To keep it from just deleting everything, it’s on a timer. Every 10 seconds, it takes one loop and chooses violence.

We spend all day interacting with black-box algorithms that curate our feeds and dictate our lives. By giving the AI direct access to my music, I’m making that struggle visible. I'm not the benevolent author anymore; I'm a negotiator trying to keep the plane flying while the co-pilot keeps setting off the fire extinguisher.

It turns performing into debugging and adapting to bad code snippets. It can be frustrating and unpredictable, but honestly? Way more fun than livecoding alone, especially when I play from scratch.

<div style="text-align:center; margin: 2rem 0;">
    <iframe 
        width="560" 
        height="315" 
        src="https://www.youtube.com/embed/jDmvSKwfzNA" 
        title="YouTube video player" 
        style="border:none; max-width: 100%;"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
        allowfullscreen>
    </iframe>
</div>

Stay glitchy 🖖
