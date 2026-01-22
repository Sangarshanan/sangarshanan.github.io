---
layout: post
title: "Esoteric performance tool with Spectrogram Art"
comments: false
keywords: "Learn"
tags:
    - music-tech
---

Spectrogram art is now new at all! Aphex twin did it in the 90s.

I learnt a lot about his work which watching [this video](https://www.youtube.com/watch?v=5wIOBBodoic)! And this is only specific to electronic music, spectrogram easter egg also feature in games like the [satanic figured hidden in Doom soundtrack](https://www.theverge.com/2016/5/31/11825606/doom-2016-soundtrack-satan-666-inverted-pentagram)

So I had an idea, it started as an attempt to turn this idea into an experimental performance tool or installation where sound is generated continuously by converting the image captured into a spectrogram.

Here is the website: <https://everything-is-a-spectrogram.vercel.app/>

To make this, I had to turn pixels and its properties to sound attributes! For each image we have

- X-axis (columns) is mapped to time (this is a constant)
- Y-axis (rows) which is mapped to the frequency
- Brightness of the image controls the volume

We can do frequency mapping with a simple geometric progressions which is basically numbers spaced evenly on a log scale, I am also quantizing these frequencies to actual musical note frequencies

```python
freqs = np.geomspace(self.MAX_FREQ, self.MIN_FREQ, self.HEIGHT)
```

Once we have the frequencies we can just and calculate the volume and finally mix the frequencies together! 

```python
for col_idx in range(self.WIDTH):
    col_intensities = pixels[:, col_idx]  # Brightness of this column
    phases = 2 * np.pi * freqs * t_global
    waves = np.sin(phases)  # Generate waves (sine/ saw, square?)
    weighted_waves = waves * col_intensities  # Scale by brightness
    col_audio = np.sum(weighted_waves, axis=0)  # Mix all frequencies
```

Here for each column (time slice), we generate sine waves for all frequencies, scale them by pixel brightness and mixes them together! The sine wave is a constant as well and can be technically replaced with any kind of synthesis.

I made a demo of this tool by fkin around with sounds on strudel.cc

<div style="text-align:center; margin: 2em 0;">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/1wc6l5TQjfs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</div>

All of the code is open source and is available here: <https://github.com/Sangarshanan/everything-is-a-spectrogram>
