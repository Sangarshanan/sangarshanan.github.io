---
layout: post
title: "You know I'm something of a Recurser myself"
comments: false
keywords: "life"
tags:
    - life
    - RC
---

I first got to know something like the Recurse center existed back in 2019 because of a bunch of cool Recursers I met at NYC during Pygotham. I kinda wrote about this experience and mentioned that "Maybe I’ll apply too" Well I did and looks like I too am a Recurser now !

![Recurse](/img/in-post/recurser.png)


The move to online batches really helped here cause I have a job that makes me happy and it would have been hard for me to travel all the way. Now its all virtual !! which is great. My good friend and former colleague/ traitor [Vinayak](https://twitter.com/vortex_ape) did an online batch recently and told he how much he wanted to go back and just keep doing more batches. I have heard similar stories from other Recursers as well, Everyone wants to go back ! and the motto literally is to **Never Graduate** and I mean if that's not exciting enough to join this amazing group of people I honestly don't know what is

I applied for the Mini Batch Feb-2021. It lasts 5 days which I know will fly away tbh I applied with just one goal in mind 'To be a part of the community' I kinda am hoping to do the longer batches as soon the place opens up and it gets easier to travel. At any given time I always have a bunch of side projects I wanna pick up and things I wanna learn so this mini batch was also a chance to maybe go knee deep into some of those things I would dip my toe and procrastinate cause they needed major effort that I did not have time for cause I truly am a lazy bastard.

Selection to a Recurse batch happens in three rounds and for the mini batch the selection process is said to be much more rigorous.  

### The Written Application ✍

So you basically just fill a form <https://www.recurse.com/apply/retreat>

Here is a condensed form of my answers to some of these questions, I am not putting in my whole application and only the interesting "cool" parts cause some of the sections are kinda generic like Cracklepop and Background.

**Please link to a program you've written from scratch**

I got super interested in the history of communication and information theory in particular, This got me 
to implement huffman trees which is THE most efficient way for assigning 0s and 1s to a single character

<https://gist.github.com/Sangarshanan/c8ed58be40dace29a5ff0ea23307d66c>

Visualizing huffman coding: <https://github.com/sangarshanan/huffman-coding/blob/master/notebook.ipynb>


**What is the most fascinating thing you've learned in the past month?**

How a seemingly deterministic system can display crazy chaotic behavior

When I was fairly new to python I learnt about random.random() this simple method in the python standard library could generate random 
numbers, it was fascinating to me that you could introduce randomness into something as deterministic as a computers. Did a little digging up
and figured out the python actually uses the current time i.e time.time() module to generate randomness but not if we know the exact time 
the method was called which is a fair assumption to make but this was not what I wanted so I ventured further into the world of randomness
and stumbled upon a Veritasium video to discover something truly amazing, Simple equations that can show chaotic behavior.
Once such equation is the Logistic Map

```math
Xn+1 = rate*Xn (1-Xn) # The value of X at time n+1 as a factor of its rate of growth 
```
I tried to visualize it myself on <https://gist.github.com/Sangarshanan/5f58efba150656cec5e7c248822e65d1>

The video pointed me to **Chaos: Making of a new science** by James Gleick, which I am currently reading and getting my mind absolutely 
blown at every single chapter

The Video: <https://www.youtube.com/watch?v=ovJcsL7vyrk> and
The Book: <https://www.goodreads.com/book/show/64582.Chaos> 


**What do you want to be doing in two years?**

> This is intentionally vague cause I honestly have no clear idea but I guess that is ok 

I want to be doing things that matter and have a positive impact on real people, 
I am kinda doing it now but I hope I can use the time to acquire the skills that can actually enable me to do so more effectively 


**Why do you want to attend RC?**

The first thing that comes to mind is the community that I would really love to be a part of and 
can look out to for advice, brainstorming and dare I say even friendship 

I am currently working and hence the mini batch and throughout the course of this job 
I have kinda always been a generalist, I got to try out a lot of cool things at work and during weekends 
with all the spare time quarantine has rained down on us so I got to narrow my niche down 
but I am still very much in limbo. I want to use recurse as an opportunity to do same exercise of
trying out new things but this time I want to do it with critiques and without having to worry about 
pagers.

End note: Just tried to keep it real with the application

### The First Round 😳

Since my written application was oozing of "awesomeness" I was invited to a conversational interview

I thought it was time for me to use my ability to mask anxiety but I did not get to use it cause this was just a really fun get-to-know-you kinda interview, Questions were mostly around why I wanted to join ? and what I expected to gain from
recurse and how I could contribute back to the community I kinda just reiterated what I mentioned in application and sprinkling a few details for effect and in the end I asked my interviewer what is the one thing about Recurse that you wish to change. My interviewer wished Recurse had more to offer to the senior folks in the community, most of the activities are geared towards beginners and they tend to have the most fun :) which is AWESOME but hey! maybe even seniors sometimes need something to often remind themselves why they do what they do ! The next round was a pair programming round.


### Pair Programming 👨‍💻

I chose Space Invaders cause Pygame was in the bucket list for a quite some time. This was also quite fun, I had written the basic structure of the game with the Player and Enemies while I added bullets and scoring during the interview. I explained what I would do next to make this game better which I actually tried to follow through with <https://github.com/Sangarshanan/vimana>


### And away we go 🎉

![Recurse](/img/in-post/recurse.jpeg)


Since it's just gonna be 5 days I am gonna try and maintain a daily journal

Unrelated note: Ughh why does LinkedIn suck so much

