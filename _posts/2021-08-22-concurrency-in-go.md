---
layout: post
title: "Concurrency in Go"
comments: false
keywords: "Learn"
tags:
    - nerd
---

Go was the language of choice for all the exercises in MIT 6.824 and because of that it introduced how Go handles some of the concurrency constructs pretty nicely, gonna explore that here ✨

![](https://miro.medium.com/max/500/1*vmFSpk9xtpxAHkH7cmt-3Q.png)

Go achieves concurrency using **Goroutines**, these are functions or methods that run concurrently with other functions or methods and can be thought of as lightweight threads managed by the Go runtime. 

Since the cost of creating a Goroutine is tiny when compared to a thread it's common for Go applications to have thousands of Goroutines running concurrently. They are mostly only a few KBs in stack size and the **stack can grow or shrink according to the needs** of the application whereas in the case of threads the stack size has to be specified and is fixed.

Prefix the function/ method call with the **keyword go** to have a new Goroutine running concurrently.

```go
package main

import (
    "fmt"
    "time"
)

func say(s string) {
    for i := 0; i < 5; i++ {
        time.Sleep(100 * time.Millisecond)
        fmt.Println(s)
    }
}

func main() {
    go say("world")
    say("hello")
}
```
Returns:
```math
world
hello
hello
world
world
hello
hello
world
world
hello
```

- The line `go say("world")` starts a new Goroutine. Now the `say("world")` function will run concurrently along with the `main()` function that runs `say("hello")`. The main function runs in its own Goroutine and it's called the **main Goroutine**
- When a new Goroutine is started it's call returns immediately and Unlike functions control does not wait for the Goroutine to finish executing which means that if `main()` terminates then the program will be terminated and no other Goroutine will run

```go
func main() {
    go say("world")
    fmt.Println("hello")
}
```

So the above function will only print `hello` and exit unless there is a `time.Sleep` method allowing `go say("world")` to execute.


Goroutines **execute in the same address space** which means you can share their memory and pass
pointers from one goroutine to another without causing a access violation. This shared memory must also be synchronized and Go offers primitives for doing this with the `sync` package but a better way to do this would be using **Channels**

### Channels


Channels are a typed conduit through which you can send and receive values with the channel operator `<-.` They can be considered as **pipes that connect concurrent goroutines**

```go
ch <- v    // Send v to channel ch
v := <-ch  // Receive from ch and assign its value to v
```
By default, **sends and receives block until the other side is ready.** This allows goroutines to synchronize without explicit locks or condition variables. The code below sums the numbers in a slice, distributing the work between two goroutines. Once both goroutines have completed their computation, it calculates the final result.

```go
package main

import "fmt"

func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum // send sum to c
}

func main() {
	s := []int{7, 2, 8, -9, 4, 0}

	c := make(chan int)
	first_half := s[:len(s)/2]
	second_half := s[len(s)/2:] 
	go sum(first_half, c)
	go sum(second_half, c)
	x, y := <-c, <-c // receive from c
	fmt.Println(x, y, x+y)
```
Returns
```math
-5 17 12
```

- Channels have **no internal capacity** and the implication of this is that for every send operation to a channel there must be a corresponding receive operation, and vice versa.

- Every **send operation will block its thread until receive** happens and vice versa.

- Go has **buffered channels which may have some internal capacity** that corresponds to a user-defined value. With buffered channels sends are non-blocking until the buffer is full and receive operations are non-blocking until the buffer is empty.

Channels are mainly used in implementing producer/consumer queues.


### Mutexes


In the block below the for loop starts 1000 goroutines each of which increments the counter variable so when this program is executed you expect the counter to be 1000 or the number of iterations but it is highly unlikely that it is 1000 because the **counter field is shared by all the goroutines.**

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	counter := 0
	for i:=0; i<1000; i++ {
		go func() {counter = counter +1}()
	}
	time.Sleep(1 * time.Second)
	fmt.Println(counter)
}
```

For example, if the current value of the counter is 10 and two goroutines try to increment the value at the same time the value of the counter after the operations will be 11 rather than the 12 we expect after two increments. We call this a **race condition** and a concurrent programs must take care to prevent it.

Go **Mutexes** help prevent race conditions by protecting critical sections in your code. Critical sections are those **blocks of code which should only be accessed by one thread at a time.** Those blocks will typically involve accessing shared variables and protecting them is essential in ensuring that your program runs predictably.

```go
package main

import (
	"fmt"
	"time"
	"sync"
)

func main() {
	counter := 0
	var mutex sync.Mutex
	for i:=0; i<1000; i++ {
		go func() {
			mutex.Lock()
			counter = counter +1
			mutex.Unlock()
		}()
	}
	time.Sleep(1 * time.Second)
	mutex.Lock()
	fmt.Println(counter)
	mutex.Unlock()
}

```
When this program is executed, the final value of the counter will be 1000, as expected.


### Condition Variables 

This primitive allows threads to wait (stop running) until they are signaled by some other thread that some condition has been fulfilled. 

In the below program we have a for loop which starts goroutines from the main goroutine and tries to gain votes from them. If it wins a vote the shared count variable is incremented. After each vote is cast the finished variable is also incremented. In the end we also have a for loop which will prevent the main goroutine from progressing until it has either won at least 5 votes or all 10 goroutines have cast their vote

```go
package main

import "time"
import "math/rand"

func main() {
	rand.Seed(time.Now().UnixNano())

	count := 0
	finished := 0

	for i := 0; i < 10; i++ {
		go func() {
			vote := requestVote()
			if vote {
				count++
			}
			finished++
		}()
	}

	for count < 5 && finished != 10 {
		// wait
	}
	if count >= 5 {
		println("received 5+ votes!")
	} else {
		println("lost")
	}
}

func requestVote() bool {
	time.Sleep(time.Duration(rand.Intn(100)) * time.Millisecond)
	return rand.Int() % 2 == 0
}
```

We have properly placed the necessary locks here so the code runs properly but the second for loop checking for the vote count to finalize results is best use of the our resources cause in each iteration it will obtain a lock, check that the condition is met and then release the lock which means there are hella unnecessary loop iterations.

Thanks to Condition Variables, we can **delay the execution of the loop** until it is possible for the break condition to have been met

```go
var mutex sync.Mutex
cond := sync.NewCond(&mutex)

mutex.Lock()
// An operation that affects the condition
cond.Broadcast()
mu.Unlock()

---
mu.Lock()
while condition == False {
    cond.Wait()
}
// the condition is True we have a lock
mu.Unlock()
```

Condition variables are perfect fit if you need to broadcast that some event has occurred to all the goroutines waiting for that particular event. Although in Go conditional variables are rarely used because of **better abstraction like Channels.**

Notes:

- <https://timilearning.com/posts/mit-6.824/lecture-5-go-threads-and-raft/>
- <https://pdos.csail.mit.edu/6.824/notes/l-go-concurrency.txt>
- <https://golang.org/ref/mem>
