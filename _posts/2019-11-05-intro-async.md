---
layout: post
title: "Writing Async with Python"
comments: false
description: Async 
keywords: "Learn"
---

< Writing In Progress > 

Bit late to this topic so I'm glad there are tons of resources around :)

There are always ways to speed up your code, you can scale horizontally or vertically but maybe you can be effective without scaling. Maybe you run multiple operations in parallel, maybe

Parallel vs Concurrent vs Async  

 - Parallel : Watch TV while eating Popcorn (You can do both of em at the simultaneously)
 
 - Concurrency: Watch Tv while checking your phone (You can deal with them simultaneously but not do em at the same time.. stop kidding yourself )

 - Async: Look at your phone when you get a notification cause your meme is poppin and then quickly back to the TV cause it's game weekkk !!!! (It is more a style of writing code)

[Amazing explanation by Rob Pike](https://www.youtube.com/watch?v=cN_DpYBzKso)

###  What is Async ? and Asyncio ?

Asynchronous Programming is a style of concurrent programming where you do multiple things at once 

There are several ways to achieve this... Asyncio is one of those ways and is quite popular 

### How can I do multiple things at once ?

- Use multiple processes. Let OS handle sharing of CPU resources
- Use multiple threads. Threads share access to common resources as you can have multiple threads in the context of one process and they need to share a common resource but in Cpython the GIL (Global interpreter lock) prevents multi core concurrency :(
- or run multiple processes on the same thread asynchronously 

When depending on the OS one needs to take care of race-conditions, dead-locks, live-locks, and resource-starvation since we have to take care of several spawned threads trying to do stuff and that is in itself is a whole other topic of discussion. AsyncIO avoids some of the potential speedbumps that you might otherwise encounter with a threaded design.

### What is Async doing ? (The chess analogy)

Async just optimizes the way things are done... it does not speed anything up. 

Suppose a chess grandmaster has to play with 10 opponents, he can play the game two ways 

- Complete the game with one and move to the next one (Sync)
- Complete a move with one and move on the next player allowing the former player to think about what to do next thus saving the time you waste on waiting for the player to make a move (Async)

Async tasks that are running release the CPU during waiting times so that other tasks can use it.. Simple


### Achieving Async without the help of your OS

So to achieve async our tasks need to release the CPU and wait and then resume after sometime, We just need python functions that can be used to Suspend / Resume and also somewhere to keep track of all the tasks that are suspended so we can resume them later  

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

Couroutines: Basically these are functions whose executions can be paused, They are used for cooperative multitasking where a process voluntarily yields control and enables multiple processes to run. When we declare a function using the async keyword the function is not run, instead, a coroutine object is returned

```python
async def hello():
	pass
print(type(hello))
```

This returns a ```<class 'coroutine'>```

There are two ways to read the output of an async function from a coroutine.

The first way is to use the await keyword, this is possible only inside async functions and will wait for the coroutine to terminate and return the result

```python
async def add_numbers(a, b):
    return a + b

async def main():
    print(await add_numbers(2, 10))

if __name__ == "__main__":
    asyncio.run(main())
```

OUTPUT: 12

The second way is to add it to an event loop

```python
async def add_numbers(a, b):
	return a + b

loop = asyncio.new_event_loop()
coroutine = add_numbers(2, 10)
task = loop.create_task(coroutine)
loop.run_until_complete(task)
print(task.result())
loop.close()
```

OUTPUT = 12



### When not use Async

- Long CPU intensive task must call sleep so that other functions get a chance too.. Release CPU to avoid starvation
This can be done by sleeping periodically, once per iteration (Just sleep(0) once per loop)

- Blocking library functions are incompatible with async frameworks (socket select subprocess threading time.sleep) 
async provides non blocking replacements for these  

- Evenlet and gevent can monkeypatch standard libraries to make it async compatible 

Eveentlet, gevent try to hide async under the rug (abstracts it away) while asyncio wants you to think asycnhronously 



### Totally ripped off these

<https://www.youtube.com/watch?v=iG6fr81xHKA>

<https://dev.to/welldone2094/async-programming-in-python-with-asyncio-12dl>