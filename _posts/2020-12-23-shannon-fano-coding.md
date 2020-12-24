---
layout: post
title: "Curb your data #2 The Mathematical Theory of Communication"
description: "A brief history of compression algorithms"
keywords: "algorithms"
tags:
    - nerd
    - cool stuff
    - series
---

Humans are not always awesome. we sometimes suck a lot, like during the world wars. While soldiers all around the world were fighting on the ground, the scientists were trying to figure out more effective means of getting information to them through popular communication signals like radio, telegraph and telephones (Propaganda was much more effective than the 3 combined)

The level of research and development in the communications–electronics field was unprecedented when scale and security became a major concern since war efforts were being controlled and coordinated using these communication channels. Communications were vital and so was intercepting and deciphering them. It was also during this time that Alan Turing broke the encryption of the Enigma machine used by Germans potentially ending the war and saving millions of lives.

In America an Emergency Technical Committee with members of Bell Labs was set up during the second world war and they proved instrumental in advancing Army and Navy ammunition acceptance and material sampling procedures. In 1943, Bell developed SIGSALY a secure system that made transmission of speech possible using pulse-code modulation. This was also the time when Alan Turing visited  Bell labs representing the British and met Claude Shannon, a mathematician from Bell Labs to discuss the project and exchange ideas.

Even after the war ended the research and collaboration continued

> **Dawn of the Information Age**

In 1948 Claude E. Shannon published an article in the Bell system technical journal called **Mathematical Theory of Communication** it quicky became one of the most cited of all scientific articles and gave rise to the field of **Information Theory**


In this paper Shannon laid out the general architecture of a communication system

![Communication System](/img/in-post/claude-shannon-1.png)

We start off with the `Information Source` that actually produces the message, then there is the `transmitter` that converts the message into a signal that would pass through a `channel`, perhaps even a noisy channel. After traversing the channel the signal reaches the `receiver` which would convert the signal back to the actual message that was sent to reach the `destination`.

We may roughly classify communication systems into three main categories: `Discrete`, `Continuous` or both. In discrete systems both the message and the signal are a sequence of discrete symbols i.e morse code while a continuous system treated both the message and signal as continuous functions like radio while a `Mixed` system would be a mix of both these systems

### Discrete Communication Systems

The Morse code was slow and using a series of dashes and dots to communicate was never going to scale, The logical next step was to design a machine geared towards speed that would allow users to input these characters directly and then convert them to low-level signals for transmission.

These teleprinters were driven by some kind of clock just like how morse code was governed by time units. The Baudot system for example used 5 different keys that could represent two states (On/ Off) with this you were able to encode 2 * 2 * 2 * 2 * 2 = 32 characters using the 5 keys and these included the alphabets and some special characters like the space bar. 

![Baudot Teleprinter](/img/in-post/baudot-teleprinter.png)

Shannon referred to the 5 different keys in the machine as **Bits** which we understand now but at the time was
 **a new way of seeing the most fundamental unit of information.**

Even over here the speed of transmission is constrained, suppose the system transmits n
symbols per second it is natural to say that the channel has a capacity of 5n bits per second. This does not
mean that the teletype channel will always be transmitting information at this rate and the actual rate depends on the source of information which feeds the channel.

We can easily observe one of the easiest way to speed up our transmission is to increase the channel capacity, by simply bumping 5 bits to 6 bits we can transmit 6n bits per second. Also instead of using each bit to represent one of two states we can represent multiple. This concept was successfully implemented in the Quadruplex telegraph where we did not just depend on On and Off but used signals of varying intensities and direction `(+1,-1,+3,-3)` to encode increase the number of messages which enabled us to send more messages without building new lines.

So why stop here why not encode a million different voltage levels per pulse and keep scaling, well we can't ! Many different voltage resolutions means its that much harder for the receiver to decipher since signals will always be accompanied with noise

**Noise in transmission is Unavoidable** it can happen due to perfectly natural causes like heat or geomagnetic storms so the signals must be different enough to be unaltered by noise.

Now this can cause issues especially when the signals are fed too fast or too slow with noise.

- Signals coming in too fast which results in inter-signal interference
- Signals coming in too slow/interrupted by noise causes echoes/smoothing of these signals 
![Signal Issues](/img/in-post/signals-issues.png)




> **Reference material**

- <http://people.math.harvard.edu/~ctm/home/text/others/shannon/entropy/entropy.pdf>
- <https://www.khanacademy.org/computing/computer-science/informationtheory#moderninfotheory>
