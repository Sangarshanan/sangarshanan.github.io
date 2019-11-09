---
layout: post
title: "Do Async IO with Python"
comments: false
description: Async 
keywords: "Learn"
---

< Writing In Progress > 

 So apparently parallel and concurrent are two different things 

 - Parallel : Watch TV while eating Popcorn (You can do both of em at the simultaneously even though not effectively)
 
 - Concurrency: Watch Tv while checking your phone (You can do them both at the same time but not simultaneously.. stop kidding yourself )


###  What is Async ? and Asyncio ?

Asynchronous Programming is a style of concurrent programming where you do multiple things at once 

There are several achieve this... Asyncio is one of those ways and is very popular 

### How can I do multiple things at once ?

- Use multiple processes. Let OS handle sharing of CPU resources
- Use multiple threads. Threads share access to common resources as you can have multiple threads in the context of one process and they need to share a common resource but in Cpython the GIL (Global interpreter lock) prevents multi core concurrency :(
- or run multiple processes on the same thread asynchronously 

When dependign on the OS one needs to take care of race-conditions, dead-locks, live-locks, and resource-starvation. So can we do Async without any help from the OS ? But first let's undertstand what async is doing


### What is Async doing ? (The chess analogy)

Async just optimizes the way things are done... it does not speed anything up. 

Suppose a chess grandmaster has to play with 10 opponents, he can play the game two ways 

- Complete the game with one and move to the next one (Sync)
- Complete a move with one and move on the next player allowing the former player to think about what to do next thus saving the time you waste on waiting for the player to make a move (Async)

Async tasks that are running release the CPU during waiting times so that other tasks can use it 


### Achieving Async without the help of OS

We just need python functions that can be Suspended and Resume (That's it)

A function enters waiting period when suspended and only resumes when the wait is over 

Several ways to implement suspend/resume in python (some below)

- Callback functions
- Generator Functions
- Async/ Await 
- Greenlets 

How do we decide which function gets the CPU next ? We need some kind of scheduler that takes care of this. We call it an event loop. Loop keeps track of all running tasks

When a function is suspended it returns control to the loop which then finds another function to start or resume

This is cooperative multitasking

Asyncio implements asynchronous code with the help of 

1) Couroutines : They are used for cooperative multitasking where a process voluntarily yields control and enables multiple processes to run. When we declare a function using the async keyword the function is not run, instead, a coroutine object is returned

Any function that begins with async is ```<class 'coroutine'>```

There are two ways to read the output of an async function from a coroutine.
The first way is to use the await keyword, this is possible only inside async functions and will wait for the coroutine to terminate and return the result



### When not be use Async

- Long CPU intensive task must call sleep so that other functions get a chance too.. Release CPU to avoid starvation
This can be done by sleeping periodically, once per iteration (Just sleep(0) once per loop)

- Blocking library functions are incompatible with async frameworks (socket select subprocess threading time.sleep) 
async provides non blocking replacements for these  

- Evenlet and gevent can monkeypatch standard libraries to make it async compatible 

Eveentlet, gevent try to hide async under the rug (abstracts it away) while asyncio wants you to think asycnhronously 







Ripped off from

<https://www.youtube.com/watch?v=iG6fr81xHKA>