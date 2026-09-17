---
layout: post
title: "Training a DDSP model for Carnatic Vocals"
comments: false
keywords: "Learn"
tags:
    - music-tech
---

This post is about the custom DDSP model I trained from scratch using Carnatic vocals from [KritiSamhita: Carnatic Tonic Recognition Dataset](https://data.mendeley.com/datasets/nkdm57hvw3/2) using 280 recordings where each recording is a 20 second chunk of audio.

For the hasty ones, Here is the result of the carnatic vocal conditional DDSP model running inference on a Pitch extracted Bansuri sample.

Input audio (Bansuri sample in Raag Yaman)

<audio controls src="/audio/in-post/ddsp-original.wav" style="width: 100%; max-width: 500px; display: block; margin: 1.5em auto 1em auto;"></audio>

Generated Audio (After 100 epochs)

<audio controls src="/audio/in-post/ddsp-generated.wav" style="width: 100%; max-width: 500px; display: block; margin: 1.5em auto 1em auto;"></audio>

Training code + Dataset to reproduce this experiment is [on Github](https://github.com/Sangarshanan/DDSP-Carnatic-Vocals)

As is tradition, the rest of the post is me rambling about this work:

Neural audio synthesis can be achieved in so many ways and each with it's own quirks. This is my opinion but currently none of the systems can really do it all in terms of real world performance requirements. Two models that are popular nowadays are RAVE and DDSP, RAVE works directly on audio and is more recent, unlike DDSP it can model any type of sound, harmonic or not, and is optimized for realtime streaming with super fast CPU inference but because of the lack of inductive bias like DDSP the output can sound quite experimental especially in the context of live performance and this becomes more tedious especially when things like following pitch of the input becomes critical. RAVE also takes more data and much longer to train.

Both of these models are just Autoencoders

![img](https://blog.neutone.space/wp-content/uploads/2022/07/autoencoder-2048x575.jpg)

This is where despite being the older methodology, I really am drawn more to Differentiable DSP, it's more interpretable than the Black box models which are annoying to train/ debug and controllable too in terms of timbre, dynamics, and pitch. It feels more intuitive because we are using DSP components as our building blocks.

For this particular project and dataset I start by defining a `DDSPSynth` which is made up of 3 components:

- **Harmonic oscillator:** An additive synthesizer that sums sinusoids at integer multiples of f0.
- **Filtered noise synth:** To model noisy vocal elements, we filter white noise in the STFT domain with a predicted magnitude envelope while preserving its random phase prior to inverse transformation.
- **Trainable FIR reverb:** Learned room impulse response applied via FFT convolution added on top of the dry harmonic + noise signal because real recordings always have room.

Together, these should help model expressive carnatic vocals.

Next component is the `DDSPEncoder` and since f0 is extracted up front by CREPE, our encoder only learns timbre. We calculate the  log-mel spectrogram of the input audio and use that to create a timbre representation with three output heads:

- **Amplitude:** Overall loudness per frame. *it's softplus, so non-negative*
- **Harmonic distribution:**  Softmax over every bin (80 bins) of harmonic amplitudes
- **Noise magnitudes:** per-frame filtered-noise spectral envelope for non tonal content. *it's a sigmoid*

These 3 control signals map into the Synthesizer we defined earlier and we slowly train the network to tune the synth and make it sound closer to the training audio. After every epoch we use a **multi-scale spectral loss** which is just the STFT magnitude differences (both linear and log-scale) computed at multiple FFT sizes and then backpropagate through our entirely differentiable synthesizer, slowly reducing the loss and tuning our synth to the training dataset.

![cooc](/img/in-post/carnatic-ddsp.png)

We can add more components depending on what we are training on, To demonstrate a simple example with code let's say we are trying to generate a harmonic synthesizer made up of just pure sine waves of different frequencies and amplitude envelopes, then we don't really need all these components. All we need is a simple `HarmonicSynth`.

```python
class HarmonicSynth(nn.Module):
    def __init__(
        self,
        sample_rate=16000,
        n_harmonics=5,
        duration=0.5
    ):
        super().__init__()
        self.sample_rate = sample_rate
        self.n_harmonics = n_harmonics
        # Time vector for the audio buffer
        self.register_buffer(
            'time',
            torch.linspace(0, duration, int(sample_rate * duration))
        )

    def forward(self, f0, amplitudes):
        # Create harmonic multiplier indices
        harmonics_idx = torch.arange(
            1, self.n_harmonics + 1,
            device=f0.device,
            dtype=torch.float32
        )
        
        # Compute instantaneous phase for each harmonic
        phases = (2.0 * torch.pi * harmonics_idx.view(1, 1, -1) 
        * f0.view(-1, 1, 1) * self.time.view(1, -1, 1))
        
        # Sinusoidal harmonics
        synth_harmonics = amplitudes * torch.sin(phases)

        # Sum across harmonics
        audio = synth_harmonics.sum(dim=-1)
        return audio
```

We can now initialize this Synthesizer and use it to generate audio at different frequencies and amplitude envelopes.


```python
# Initialize synthesizer
synth = HarmonicSynth()

true_f0 = torch.tensor([220, 440]) # hz
true_amps = torch.tensor([[1.0, 0.5, 0.25, 0.125, 0.0625]])

target_audio = synth(
        true_f0,
        # Expand amplitudes across the time dimension
        true_amps.unsqueeze(1).expand(-1, time_steps, -1)
)
```

We define our learnable parameters which is basically our harmonics, an optimizer, here I use Adam and a loss function which is an MSE loss rather than a multi-scale spectral loss. There are quite a few audio focused loss functions [here](https://github.com/csteinmetz1/auraloss) to use depending the target audio.

```python
learned_amps = nn.Parameter(torch.rand(1, n_harmonics) * 0.1)
optimizer = optim.Adam([learned_amps], lr=0.05)
criterion = nn.MSELoss()
```

All that is left now is to train, And at every epoch we can see that the sound converges close to the original audio until it eventually converges but this is the simplest implementation possible that just acts as a demonstration.

![](/img/in-post/ddsp-animation.gif)

```python
# Start Gradient Descent Loop
for epoch in range(150):
    optimizer.zero_grad()

    # Forward pass: generate audio from current parameter estimates
    pred_audio = synth(
        true_f0,
        learned_amps.unsqueeze(1).expand(-1, time_steps, -1)
    )

    # Compute loss
    loss = criterion(pred_audio, target_audio)

    # Back Propagate
    loss.backward()
    optimizer.step()
```

But the idea here remains the same, we can make our Encoder and Synth as complex as possible depending on the properties of the sound we want to capture but there are some issues.

**Optimizing frequency is hard** Multiple sinusoidal functions which go up and down continuously might drift in and out of phase with each other, So sometimes the peaks align (making the error look small), and sometimes they clash (making the error look massive). I avoid this problem all together by directly using CREPE to estimate frequencies.

**Non Harmonic Sounds** especially with sharp transients, like drums, get smeared and this happens to other non harmonic sounds too. There are a lot of ideas focused specifically on [Drum synthesis](https://dael.euracoustics.org/confs/fa2023/data/articles/001093.pdf) and [RAVE](https://github.com/acids-ircam/rave) is much better for textures and other misc sounds.

**Inference Time** can be an overhead for DDSP especially when run on CPU hardware and even though there are solutions that address running DDSP realtime, it typically involves compromises in either the model architecture, GPU or with really big buffer sizes.

There is [NEWT](https://ar5iv.labs.arxiv.org/html/2107.05050) which has a very simple architecture like DDSP but uses waveshaping synthesis and in the end we train the model to learn our waveshaping functions that can be mixed downstream to get our resulting waveform and with these precomputed functions, a lookup table can be used during inference instead of an expensive neural network for real time CPU performance, and [existing research](https://ieeexplore.ieee.org/document/9747844) also shows that replacing GRU with a dilated convolution network in DDSP’s decoder resulted in faster inference time and similar quality.

The recent developments in neural audio codecs are also really exciting cause they can help optimize neural audio synthesis. There are definitely gaps to address. As we saw, the two biggest models in the scene come with their own set of baggage. There's a lot of work to do before these models can run smoothly across everyday machines and be used for non-experimental musical performances and I am gonna continue playing around with all that is cool and interesting :)


### References

- [Magenta DDSP](https://magenta.withgoogle.com/ddsp)
- [Intro 2 DDSP](https://intro2ddsp.github.io/intro.html)
- [Accelerating Neural Audio Synthesis](https://www.research-collection.ethz.ch/server/api/core/bitstreams/98cad3d4-cc89-4581-a84a-9abfaef665d2/content)
- [Neural timbre transfer effects for neutone
](https://neutone.jp/blog/neural-timbre-transfer-effects-for-neutone)
