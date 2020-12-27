---
layout: post
title: "Morse Code & The Beginning of an era"
description: "The Era of Communication"
keywords: "algorithms"
tags:
    - series
    - information theory
---


Humans are social animals, we rely on friends and family maybe now it's just for social juice but when we were still living in jungles staying together meant better higher chances of survival. We have evolved by cooperating as a civilization and we were able to continue that cooperation for generations with effective communication.

Humans are also expansionists we like to explore into the unknown whether it is across towns, cities, countries, planets, solar systems, galaxies or even super clusters and as we humans explored places on earth and set up colonies it got a bit harder to communicate across colonies that were a bit far apart, we started by using natural resources for long term communication, smoke signals and drumbeats were common means of communications in almost all ancient civilizations. But this was limited by the weather and line of sight. We mitigated the line of sight issue by setting up communication channels on hill tops by this too was limited by the weather.

We then started developing infrastructure for long term communication, animals like pigeons and even human messengers were trained to deliver messages across long distances. This was obviously was slow but kinda worked out for a while



> **Enter Electricity**

Around 600 BC the Greek mathematician Thales of Miletus observed something interesting, certain stones like amber when rubbed against fur would showcase a strange force that could attract small fibers. Not only this it was also observed that when you try to touch this invisible force it would give you a shock and then immediately disappear. Also not every object would allow the flow of this force, today we know these objects as conductors.

In 1752 Benjamin Franklin would discover that the tiny shocks we get from the force of friction between certain objects as discussed above were also the same force observed in lightning as it gave him the same shock, Not only this he was also able to store this so called energy in a glass jar filled with water a protruding wire and discharge it all will by connecting wires or touching the jar. This was the very first Capacitor. 

Once we discovered about free flowing of electrons across opposing charges, it's resulting magnetic field and an effective way to store and transmit this electrical power over a conductor there was no turning back. Electricity kinda like fire was a quicksave in the species game.

The Electric Telegraph was a result of two developments in the field of electricity. First, in 1800, the Italian physicist Alessandro Volta invented the battery, which reliably stored electric current and allowed it to be used in a controlled environment. Second, in 1820, the Danish physicist Hans Christian Oersted demonstrated the connection between electricity and magnetism by deflecting a magnetic needle with an electric current.

In the 1830s, the British team of Cooke and Wheatstone developed a telegraph system, It was suddenly possible to communicate with electricity over long distances by just laying some wires. 

But there was an issue they could only communicate through pulses of electricity. This where Samuel Morse came in he developed a sorta code, more particularly morse code to translate these pulses to numbers. He later sought help from Alfred Vail and Leonard Gale to expand it's scope to letters and other characters.

The code assigned a sequence and short and long pulses to numbers and letters. These pulses can also be described as dots and dashes, For example the code for A is `🔴 🚥` a dot followed by a dash. Each dot represents one time unit and a dash represents three time units, there is also a silence of 1 time unit in between every pulse.

Here is the interesting problem statement 

> Which specific sequence to dots and dashes do you assign to a character ?

To do this they actually studied the frequency of usage of every character in the english language and assigned easier sequences to the more commonly used characters. So `E` the most commonly used letter is represented with a single 🔴 dot.

Morse codes were a gamechanger and was a huge step towards enabling humans to communicate over really long distances like never before. Even now in maritime and a bunch of other places we use `SOS` as a signal for distress calls and the combination of these letters were chosen purely for their simplicity in morse code.

On an entirely different note, Samuel Morse was a painter by profession. The city of New York promised him a $1,000 commission to paint Marquis de Lafayette and while working on the painting he got a letter from a man on horseback and the letter said that his wife Lucretia had passed away and by the time he rushed back to see her one last time she was already buried, perhaps it was this heartbeat and pain caused by slow communication that gave us morse code.  

Despite being a little hard and not intuitive to learn once mastered morse code is actually one of the easiest means of communication, It has been used by spies to deliver secret messages which to an unsuspecting onlooker might seem like weird blinking or tapping. There have also been multiple references to it in pop culture, more recently I saw one in the movie parasite where (spoiler alert) the man who lives inside the mansion communicates with it's owner by banging his dead and switching the lights on and off in morse code.

Now, this seems all too familiar to like minds, morse code using two types of pulses short and long to encode information which is kinda what every computer ever does right ? so is this all just an elaborate ploy by the omnipresent 1 and 0s

So it's all binary then ?

Ehhhhh not exactly, so the think is with morse code we have a gap of one time unit between dots and dashes, to separate letters we use the three time units and to separate words we use seven time units 

So morse code is no exactly a binary system but a ternary system cause we also need to account for silence or gaps i.e time units when there are no pulses. 


That's is not stopping us from representing this in binary

- A dot is denoted by a `10` 1 representing the time unit and 0 representing the end of the pulse
- A dash is denoted by `110` where 111 represents 3 time units and it too ends with a 0 to denote the one time unit gap or the end of a pulse
- A gap is denoted by `00` which is two time units of nothingness so when combined with either a dot or a dash mean a letter separator and 3 continuos gaps represent the end of the word

And there you have it !

|--------+------+--------+-----------|
| Letter | Code | Length | Frequency |
|--------+------+--------+-----------|
| E      | 🔴    |      1 |    12.49% |
| T      | 🚥    |      3 |     9.28% |
| A      | 🔴🚥   |      4 |     8.04% |
| O      | 🚥🚥🚥  |      9 |     7.64% |
| I      | 🔴   |      2 |     7.57% |
| N      | 🚥🔴   |      4 |     7.23% |
| S      | 🔴  |      3 |     6.51% |
| R      | 🔴🚥🔴  |      5 |     6.28% |
| H      | 🔴 |      4 |     5.05% |
| L      | 🔴🚥🔴 |      6 |     4.7% |
| D      | 🚥🔴  |      5 |     3.82% |
| C      | 🚥🔴🚥🔴 |      8 |     3.34% |
| U      | 🔴🚥  |      5 |     2.73% |
| M      | 🚥🚥   |      6 |     2.51% |
| F      | 🔴🚥🔴 |      6 |     2.40% |
| P      | 🔴🚥🚥🔴 |      8 |     2.14% |
| G      | 🚥🚥🔴  |      7 |     1.87% |
| W      | 🔴🚥🚥  |      7 |     1.68% |
| Y      | 🚥🔴🚥🚥 |     10 |     1.66% |
| B      | 🚥🔴 |      6 |     1.48% |
| V      | 🔴🚥 |      6 |     1.05% |
| K      | 🚥🔴🚥  |      7 |     0.54% |
| X      | 🚥🔴🚥 |      8 |     0.23% |
| J      | 🔴🚥🚥🚥 |     10 |     0.16% |
| Q      | 🚥🚥🔴🚥 |     10 |     0.12% |
| Z      | 🚥🚥🔴 |      8 |     0.09% |
|--------+------+--------+-----------|

The representations in morse code was designed so that the most frequently used letters have the shortest codes. In general, code length increases as frequency decreases.

This is actually a form of data compression and perhaps one of the earliest if not the first one.

More work on compression was brought by pioneers of information theory, In 1949 Claude Shannon and Robert Fano devised a systematic way to assign codewords based on probabilities of blocks

Even the morse code can be represented in graphical form, We have dots, dashes, word space and letter spaces and There are two states depending on whether or not a space was the last symbol transmitted. If so, then only a dot or a dash can be sent next and the state always changes. If not, any symbol can be transmitted and the state changes if a space is sent or remains the same. 

![graph](/img/in-post/makov-chain-shannon.png)

This concept of **Modelling Sequences of random events using states and transitions between them is called a Markov Chain**

This markov chain in the image above was presented in Claude Shannon's paper titled The Mathematical Theory of Communication, the paper which laid the foundations of modern information theory.

It was also in this paper that Shannon introduced the Shannon-Fano coding, a technique for lossless data compression, this was preceded by a more optimal algorithm proposed by David Huffman in 1951, it was called Huffman encoding.

Ah yes back when naming things after yourself was cOoL

> Reference material

- <https://www.history.com/topics/inventions/telegraph>
- <https://www.youtube.com/watch?v=HY_OIwideLg> of course it's a Vsauce video
- <https://www.khanacademy.org/computing/computer-science/informationtheory/>
