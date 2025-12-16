---
layout: post
title: "ByteBeat: Music with one line of code"
comments: false
keywords: "Learn"
tags:
    - music-tech
---

 Livecoding music involves writing a lot of code, this gets tedious real soon and becomes a challenge to play live or start from a blank state, so lately I have been exploring ways to make music with less code and I ended up finding something that takes this to the extreme and it kinda blew my mind!

**Bytebeat: Experimental music from very short C programs**

In 2011, a [YouTube video](https://www.youtube.com/watch?v=tCRPUv8V22o) showcases seven impossibly short C programs! These programs, some containing as few as three arithmetic operations, could generate audio that actually sounded like music when output as raw sound data.

The beauty of these programs lies in their simplicity. Each one follows a basic pattern: increment a counter variable `t` infinitely, run it through some mathematical expression, and output the result as audio. That's it. No synthesizers, no sound libraries, just raw arithmetic outputting 8000 samples per second, producing a waveform with 256 amplitude levels.

What makes bytebeat super interesting is how it discovered novel ways to make music using **bitwise operations**, which had rarely (if ever) been used for music generation before!

Let us take this simple piece of code

```math
t&t>>8
```

Its literally 6 characters and is called the **Sierpinski harmony**. This expression creates what sounds like a multitonal melody with mostly octave intervals. Why? Because the **bitwise AND operation splits a simple sawtooth wave into its component square waves**, and when these components appear suddenly, our brains interpret them as separate musical notes. The visual pattern of its amplitude values even resembles a Sierpinski triangle, hence the name.


Try running it below and feel free to play around with the different patterns, maybe make your own 👀


<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bytebeat</title>
</head>
<body>
    <h3>Bytebeat</h3>
    <input type="text" id="expr" value="t&t>>8" placeholder="Enter expression (use variable t)">
    <button id="play">Play</button>
    <button id="stop" disabled>Stop</button>
    
    <p>Examples:</p>
    <ul>
        <li><a href="#" onclick="load('t&t>>8')">t&t>>8</a> - Sierpinski</li>
        <li><a href="#" onclick="load('t*(42&t>>10)')">t*(42&t>>10)</a> - Forty-Two</li>
        <li><a href="#" onclick="load('t*5&t>>7|t*3&t>>10')">t*5&t>>7|t*3&t>>10</a> - Lullaby</li>
        <li><a href="#" onclick="load('t*9&t>>4|t*5&t>>7|t*3&t>>10')">t*9&t>>4|t*5&t>>7|t*3&t>>10</a> - Complex</li>
    </ul>

    <script>
        let ctx, node, t = 0, playing = false;
        const rate = 8000;

        function load(expr) {
            document.getElementById('expr').value = expr;
            return false;
        }

        function evaluate(expr, t) {
            try {
                return new Function('t', `return (${expr}) & 255;`)(t);
            } catch (e) {
                return 128;
            }
        }

        document.getElementById('play').onclick = () => {
            if (playing) return;
            ctx = new (window.AudioContext || window.webkitAudioContext)({ sampleRate: rate });
            node = ctx.createScriptProcessor(4096, 0, 1);
            const expr = document.getElementById('expr').value;
            
            node.onaudioprocess = (e) => {
                const out = e.outputBuffer.getChannelData(0);
                for (let i = 0; i < out.length; i++) {
                    out[i] = (evaluate(expr, t++) - 128) / 128.0;
                }
            };
            
            node.connect(ctx.destination);
            playing = true;
            document.getElementById('play').disabled = true;
            document.getElementById('stop').disabled = false;
        };

        document.getElementById('stop').onclick = () => {
            if (!playing) return;
            node.disconnect();
            ctx.close();
            node = ctx = null;
            t = 0;
            playing = false;
            document.getElementById('play').disabled = false;
            document.getElementById('stop').disabled = true;
        };

        document.getElementById('expr').onkeypress = (e) => {
            if (e.key === 'Enter') {
                document.getElementById(playing ? 'stop' : 'play').click();
                if (playing) setTimeout(() => document.getElementById('play').click(), 100);
            }
        };
    </script>
</body>
</html>


Bytebeat is esoteric and weird, Many contributors admitted they had no idea why their expressions worked and they just stumbled upon them. The **Forty-Two Melody** `t*(42&t>>10)` was independently discovered by at least three people, itgenerates a musical sequence just by masking bits with the number 42. How cool is that?!

Other discoveries used integer overflow, normally considered a bug to avoid as a deliberate musical effect. Subtracting 1 in the right place could suddenly add percussion. Division by zero, which would crash most programs, created interesting textures in this chaotic space.

Bytebeat happened on the same year i.e 2011 the term **Algorave** was coined by Alex McLean and Nick Collins during a car ride on the M1 motorway in the UK while heading to a gig! This spawned tools that let anyone experiment in real time, adjusting expressions and immediately hearing the results. It influenced artistic communities like demoscene, glitch art, live coding, and led to new software projects exploring even more constrained programming environments.

I found this really cool resource to get started with this tool <https://github.com/TuesdayNightMachines/Bytebeats/blob/master/Bytebeats_Beginners_Guide_TTNM_v1-5.pdf> It explains what the mathematical and bitwise operators do, slowly building up to a step sequencer! It's also too much to just fuck around with the examples and make cool beats.
