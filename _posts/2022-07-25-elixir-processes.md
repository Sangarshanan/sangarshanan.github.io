---
layout: post
title: "Elixir processes for concurrency and coolness"
comments: false
keywords: "Learn"
tags:
    - nerd
---


I know this might not be a "politically correct" thing to say but i really enjoy writing code without thinking about the performance, I just want to focus on the fun part and if something is slow I will just throw in more memory and maybe wait for better hardware but that does not always work , Moore's law works its magic at its own pace and i aint gonna wait for faster hardware to speed shit up. For more performance NOW **I need to exploit multiple cores.** the need for concurrency

>  **The free lunch is over**


turning to concurrency we have several models to use depending on the programming language, we have some cool async stuff we can do with Python, go has channels which are cute lil pipes to talk across routines but elixir has a model quite different and i honestly think its kinda neat

### The Actor Model

Most functional languages avoid mutable state in concurrency by just making state immutable but actors by contrast **retains mutable state but avoids sharing it** they kinda act like objects that can communicate with other actors throught messages which is nothing but calling a method.

 > In Elixir an actor is called a process. In most environments a process is a heavyweight entity that consumes lots of resources and is expensive to create. An Elixir process, by contrast, is very lightweight—lighter weight even than most systems’ threads, both in terms of resource consumption and startup cost. Elixir programs typically create thousands of processes without problems and don’t normally need to resort to the equivalent of thread pools

because of this processes are expendable and we can literally just spin up more anytime and elixir also has an inherent **supervisor** that detects if a process is dead and starts a new one, ensuring fault tolerance and allows us to both scale beyond a single machine

##### This is the "Let it crash" philosophy

which is an obvious assumption to make as a wise insurance salesman one said: If it can crash it will crash.

> `spawn` : used for spawning new processes and returns pid

```elixir
iex> spawn(fn -> "hello" end)
#PID<0.111.0>
```
> `send` : send a message asynchronously wrt to pid which gets added to a the process mailbox

An actor runs concurrently with other actors but handles messages sequentially i.e in the order they were added to the mailbox, moving on to the next message only when it’s finished processing the current message.

```elixir
pid = spawn(&SomeClass.loop/0)
send(pid, {:welcome, "Jack"})
```
> `receive`: infinite loop that handles the messages in the mailbox

```elixir
def loop do
    receive do
        {:welcome, name} -> Io.puts("Welcome #{name}")
    end
    loop
end
```

If there is no message in the mailbox matching any of the patterns handled in receive, the current process will wait until a matching message arrives, Alternatively a timeout can also be specified

```elixir
receive do
    {:pattern, msg} -> msg
after
    1_000 -> "nothing after 1sec"
end
```

The below example is a bit more interesting cause now the process has a state and an incrementing counter. we do not need mutable variables to create a stateful process but rather just recursion. the defined `Counter` is stateful actor without mutable variables and furthermore, can safely access state without any concurrency bugs because messages are handled sequentially.


```elixir
defmodule Counter do
  """
  iex(1)> counter = Counter.start(10)
  #PID<0.161.0>
  iex(2)> Counter.increment(counter)
  11
  iex(3)> Counter.increment(counter)
  12
  """

  def start(count) do
    # __MODULE__: name of the current module
    spawn(__MODULE__, :loop, [count])
  end

  def increment(counter) do
    # generate a unique reference to send reply from loop
    ref = make_ref()
    send(counter, {:next, self(), ref})
    receive do
        # return the sent count from loop
        {:ok, ^ref, count} -> count
    end 
  end

  def loop(count) do 
    receive do
      {:next, sender, ref} ->
        # increment the count and send 
        send(sender, {:ok, ref, count+1})
        # recursively get ready to receive 
        # another msg with an updated state
        loop(count + 1)
    end 
  end
end

```

passing the `counter` around every time so we can increment is a little frustrating but elixir has a way to make its processes discoverable internally so we can avoid this drama, One can `register` a name for a process

```elixir
Process.register(pid, :counter)
counter = Process.whereis(:counter)
```

so in `send` can take a process name instead of a process identifier directly

```elixir
def start(count) do
    pid = spawn(__MODULE__, :loop, [count])
    Process.register(pid, :counter)
    pid
end

def increment do
    ref = make_ref()
    send(:counter, {:next, self(), ref})
    receive do
        {:ok, ^ref, count} -> count
    end 
end

#### 
iex(1)> Counter.start(10) 
#PID<0.121.0>
iex(2)> Counter.increment
11
```
    
In elixir funcs are first class & like all func languages we have anonymous funcs

```elixir
> Enum.map([1, 2, 3, 4], fn(x) -> x * 2 end)
[2, 4, 6, 8]
``` 

Elixir also provides a shorthand &(...) syntax for defining anonymous functions

```elixir
iex(2)> Enum.map([1, 2, 3, 4], &(&1 * 2))
[2, 4, 6, 8]
```

But this map() function maps a function over a collection sequentially. Well we can add some actors into this mix and run our own theatre oh sorry I meant a parallel map

```elixir
# PARALLEL MAP

defmodule Parallel do
  def map(collection, fun) do
    parent = self()

    processes = Enum.map(collection, fn(e) ->
        spawn_link(fn() -> 
            send(parent, {self(), fun.(e)})
          end)
      end)

    Enum.map(processes, fn(pid) ->
        receive do 
          {^pid, result} -> result
        end
      end)
  end
end

"""
Execution

iex(1)> slow_double = fn(x) -> :timer.sleep(1000); x * 2 end

iex(2)> :timer.tc(fn() -> Enum.map([1, 2, 3, 4], slow_double) end) 
{4003414, [2, 4, 6, 8]} # SLOWER

iex(3)> :timer.tc(fn() -> Parallel.map([1, 2, 3, 4], slow_double) end) 
{1001131, [2, 4, 6, 8]} # FASTER
"""
```


This executes in two phases. In the first, it creates one process for each element of the collection (if the collection has 1,000 elements, it will create 1,000 processes). Each of these applies fun to the relevant element and sends the result back to the parent process. In the second phase, the parent waits for each result.

We also have **Tasks** built on top of spawn they provide better error reports and introspection, 

Unlike Spawn, Task will return `{:ok, pid}` rather than just the `PID`. This is what enables tasks to be used in supervision trees. Furthermore, Task provides convenience functions, like `Task.async/1` and `Task.await/1`, and functionality to ease distribution.

Elixir provides fault detection by allowing processes to be linked, we can define `spawn_link` & `task_sink` which are bidirectional in nature meaning if a process gets killed when it fails it also kills the linked process,Links propagate errors & instead of exiting when a linked process terminates abnormally, it’s notified with an `:EXIT` message. 

All these properties of linked processes can be used to create **Supervisors** that handles these failures and spins us new processes as and when required.

There is so much more to explore

Reading...

- **Seven Concurrency Models in Seven Weeks** <https://github.com/islomar/seven-concurrency-models-in-seven-weeks/tree/master/Actors>
- <https://elixir-lang.org/getting-started/processes.html>
- <https://www.brianstorti.com/the-actor-model/>
- <https://elixirschool.com/en/lessons/intermediate/concurrency>