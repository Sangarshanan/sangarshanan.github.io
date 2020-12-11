---
layout: post
title: "Hamming codes are cool"
description: "Elegant Algorithms"
keywords: "algorithms"
tags:
    - algorithms that make me cry
---

## Algorithms that make me cry: Hamming Codes


I learnt about hamming codes in college, I did not find them remotely interesting and I did not bother learning more

Recently I came across the impossible chessboard puzzle on 3Blue1Brown


<iframe width="420" height="315"
src="https://www.youtube.com/embed/wTJI_WuZSwE?autoplay=0&mute=1">
</iframe>

tl;dr So we have a checkerboard with coins placed in a random order of heads and tails and a prize under one of the boards. Now by only disturbing a single piece on the board we should indicate the position of the prize to our teammate with whom we can collude with beforehand.

This problem is a solid, battle tested way to lose friends at parties.

At first glance it seems super crazy, there is no way you can alter just one coin to indicate a position when you have so many choices and combinations in front of you, its hard to properly understand the problem at this scale, so like a cute little engineer you break it down to a much smaller problem

Lets say we have two board, the combinations possible are 

`[H H], [T T], [H T], [T H]`

Here is the rule: If the first coin is `Head` its under the first board or its on the second board

easy peasy right, now lets add to the combination and try to visualize this with 3 coins

This is where the video gets better cause to understand this problem properly at a higher dimension visualization is the key. we can represent the 4 combinations previously presented as a square where the two opposite sides indicate the two positions the key can reside, 3B1B beautifully illustrates this in 3D and goes onto explain why it would actually not work for combination that are not a power of 2, also how you can elegantly scale the solution from 2 boards to 64 boards.

The underlying algorithm is something that we actually use in our daily life, oh this is where the beautiful error correction algorithms come in, When we have information encoded as a combination of 1s and 0s passing through a noisy channel there is a high possibility that a few get flipped and we must be able to identify these flipped bits without any knowledge on the initial state.

Now there are several error correction algorithms ranging in complexities and efficiency, some of the popular ones include Hamming codes, BCH codes, Reed solomen codes and so on, we can gonna explore hamming codes. 

Again 3B1B made two excellent videos illustrating hamming codes the hardware and the software


<iframe width="420" height="315"
src="https://www.youtube.com/embed/X8jsijhllIA?autoplay=0&mute=1">
</iframe>


I tried to convert the code he presented in part 2 to something barely working

<https://gist.github.com/Sangarshanan/217d800c7a2e11dc5d1137de40ba00f2>

