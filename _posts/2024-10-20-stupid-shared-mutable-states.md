---
layout: post
title: "Stupid shared mutable states & Distributed Locks"
comments: false
keywords: "Learn"
tags:
    - nerd
---

Functional programming is an acquired taste, the paradigm shift felt too jarring! tf you mean i need to use recursion to iterate thro a list? Once i stuck thro it and started to approach problems like that coming back to Python made me throw up a lil bit, my sickness started when i discovered how Python handles variables, particularly when there is a shared mutable state.

I have run out of count the times i had to debug issues where i edited a variable that was sliced or referenced elsewhere only to find out that i had to make a copy before editing cause Python has just one reference to all those different names i call the same damn thing. It makes it easier to write code but reasoning and debugging is so hard! and when you run things in a distributed manner it gets so bad that i sometimes even contemplate becoming a product manager.

I have been wanting to explore some of this in Python and finally do some long overdue technical writing this weekend, I started with a class that is well renowned for fucking up states, the "Account" class: An account starts with 0 balance & it can be incremented or decremented which changes the balance in the account. Simple!


```python
class Account(object):
	def __init__(self, data=0):
		self.data = data

	def plus_data(self, val):
		added_data = self.data + val
		self.data = added_data

	def minus_data(self, val):
		if self.data >= 0:
			removed_data = self.data - val
			self.data = removed_data
		else:
			raise ValueError("Negative data")

	def get(self):
		return self.data

a = Account()
a.plus_data(100)
a.minus_data(50)
print(a.get()) # 50
```

What if multiple threads are editing this in parallel? To do this I added a [ThreadPoolExecutor](https://docs.python.org/3/library/concurrent.futures.html) for launching parallel tasks

```python
a = Account()
with ThreadPoolExecutor(max_workers=2) as executor:
    executor.submit(a.plus_data, 400)
    executor.submit(a.minus_data, 100)
```

But then this does not change anything in the results and it is as if the methods are synchronous, which it kinda is because the `plus_data` & `minus_data` have no workload and execute almost instantaneously, So mock a processing to truly tap into async lets add a delay.

```python
import time
from concurrent.futures import ThreadPoolExecutor

class Account(object):
	def __init__(self, data=0):
		self.data = data

	def plus_data(self, val):
		added_data = self.data + val
		time.sleep(0.2) # processing simulation
		self.data = added_data

	def minus_data(self, val):
		if self.data >= 0:
			removed_data = self.data - val
			time.sleep(0.2) # processing simulation
			self.data = removed_data
		else:
			raise ValueError("Negative data")

	def get(self):
		return self.data

a = Account()

with ThreadPoolExecutor(max_workers=2) as executor:
    executor.submit(a.plus_data, 400)
    executor.submit(a.minus_data, 100)
    executor.submit(a.plus_data, 100)
    executor.submit(a.plus_data, 200)
    executor.submit(a.minus_data, 50)

print("Sync value:", 400 - 100 + 100 + 200 - 50)
print("Async value:", a.get())
```

This does fuck things up as expected every time i run.

```bash
>> python 2.py
Sync value: "550"
Async value: "450"

>> python 2.py
Sync value: "550"
Async value: "-100"

>> python 2.py
Sync value: "550"
Async value: "200"
```

And things only get more fucked up as i tune the sleep i,e `processing time` as well as the `max_workers` parameter.

The reason for this is literally in the title of this post **Shared Mutable State**

![SMS](/img/in-post/sms.jpeg)

There are a couple of ways to fix this, we can use thread safe data structures to make mutations like we do in languages like golang using channels, in Python we have bunch of `collections`  objects like Counter, Queue and Dequeue which are thread safe!

```python
class Account(object):
	def __init__(self, data=0):
		self.data = queue.Queue()
		self.data.put(0)

	def plus_data(self, val):
		added_data = self.data.get() + val
		time.sleep(0.2) # processing simulation
		self.data.put(added_data)

	def minus_data(self, val):
		removed_data = self.data.get() - val
		time.sleep(0.2) # processing simulation
		self.data.put(removed_data)

	def get(self):
		return self.data.get()
```

Lesgoo! now this returns 550 consistently

```bash
>> python3 3.py
Sync value: 550
Async value: 550
```

We can also use primitives like locks to achieve the same atomicity we got with thread safe objects which internally uses PyMutex i.e a type of lock.

```python
lock = threading.RLock()
with lock:
	fun()
```

I'll be honest, I have never used any of these approaches to guarantee thread safety
for shared mutable states when writing Python code. 
This is because distributed systems typically don't just run multiple threads;
they operate across multiple machines and with that comes more complexity

- **Deadlock:** Two or more processes are unable to proceed because
each is waiting for the other to release resources causing it to freeze indefinitely
- **Livelock:** Similar to a deadlock, except that the states of the processes involved in 
  the livelock constantly change with regard to one another, none progressing, 
  it's a special case of resource starvation.
- **Timeout Mechanism:** If any process fails to release a lock within a certain timeframe,
  the lock is automatically released to prevent system hang
- **Performance Bottlenecks:** Preventing concurrent modification of a data item & 
  Ensuring that locks are held for the minimum required time is crucial for avoiding
  contention and improving system performance.


One way is implementing distributed locks is thought Redis! Redlock used 
multiple Redis nodes to achieve distributed locking and the algorithm provides
strong consistency guarantees and protection against most failures, 
including network partitions and Redis node crashes 

There are a number of libraries implementing a Distributed Lock Manager with Redis but
they all mostly follow the same approach! In order to acquire the lock,
the client performs the following operations:

- It gets the current time in milliseconds.
- It tries to acquire the lock in all the N instances sequentially, using the same key name and random value in all the instances. During step 2, when setting the lock in each instance, the client uses a timeout which is small compared to the total lock auto-release time in order to acquire it. For example if the auto-release time is 10 seconds, the timeout could be in the ~ 5-50 milliseconds range. This prevents the client from remaining blocked for a long time trying to talk with a Redis node which is down: if an instance is not available, we should try to talk with the next instance ASAP.
- The client computes how much time elapsed in order to acquire the lock, by subtracting from the current time the timestamp obtained in step 1. If and only if the client was able to acquire the lock in the majority of the instances (at least 3), and the total time elapsed to acquire the lock is less than lock validity time, the lock is considered to be acquired.
- If the lock was acquired, its validity time is considered to be the initial validity time minus the time elapsed, as computed in step 3.
- If the client failed to acquire the lock for some reason (either it was not able to lock N/2+1 instances or the validity time is negative), it will try to unlock all the instances (even the instances it believed it was not able to lock).

[pottery](https://github.com/brainix/pottery?tab=readme-ov-file#redlock) implements Redlock 
as close to `threading.Lock` API as is feasible, While Redlock can coordinate 
access to a resource shared across different machines; `threading.Lock` can't

```python
import redis
from pottery import Redlock
from time import sleep

rc = redis.Redis(host='localhost', port=6379, db=0)
redis_lock = Redlock(key='secret', masters={rc}, auto_release_time=.2)
```

The `key` argument represents the resource, and the `masters` argument specifies 
your Redis masters across which to distribute the lock. 
In production, you should have 5 Redis masters. 
This is to eliminate a single point of failure 
— you can lose up to 2 out of the 5 Redis masters and your 
Redlock will remain available and performant.

`auto_release_time` here represents the timeout to release the lock, 
Redlocks are automatically released (by default, after 10 seconds). 
we should ensure that the critical section completes well within that timeout. 
The reasons that Redlocks are automatically released are to preserve “liveness” and to avoid deadlocks 
(in the event that a process dies inside a critical section before it releases its lock).


```python
>>> with redis_lock:
...     print('secret is locked')
secret is locked
>>> bool(redis_lock.locked())
False
```

It's safest to instantiate a new Redlock object every time you need to protect
your resource and to not share Redlock instances across different parts of code as 
instantiating a new Redlock every time you need a lock sidesteps bugs 
by decoupling how you use Redlock from the forking/threading model of your application/service.

There is an interesting argument by Martin Kleppmann against Redlock: He claims:
> **If you are using locks merely for efficiency purposes, it is unnecessary to incur the cost and complexity of Redlock, running 5 Redis servers and checking for a majority to acquire your lock. You are better off just using a single Redis instance, perhaps with asynchronous replication to a secondary instance in case the primary crashes.**

<https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html>

Here, he details about why he thinks Redlock is unsafe and asks to look 
at consensus systems Zookeeper that has extensive history of use in production grade systems
like Kafka and Cassandra, He posits that Redlocks are unnecessarily heavyweight and expensive for efficiency-optimization locks, but it is not sufficiently safe when correctness depends on the lock.

There is also an interesting rebuttal by antirez that is relevant here: <http://antirez.com/news/101>

- We should use **fencing tokens** (monotonically increasing token that increments 
  whenever a client acquires the lock) for processes that can take significant time rather than extending locks' lifetime cause 
if the client holding the lock crashes and does not recover with full state in a 
short amount of time, a deadlock is created where the shared resource that the 
distributed lock tried to protect remains forever unaccessible

- Redis does not use a monotonic clock but rather a semi synchronous system model 
  where different processes can count time at more or less the same “speed” 
  which means that a wall-clock shift may 
  result in a lock being acquired by more than one process, To solve Redis should switch to
  a monotonic time API provided by most operating systems tho it can be mitigated to a large
  extent by preventing admins from manually setting the server's time and setting up NTP properly

We've come a long way from managing mutable variables in single-threaded applications. 
Distributed locking opens up an entirely new rabbit hole—there's far too much to explore
and i have barely touched the intricacies.

I am gonna read up more and maybe write another post! hopefully it won't end up in the
drafts with the gazillion other shit i want to write a blog about.

ta ta until then 👋
