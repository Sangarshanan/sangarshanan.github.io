---
layout: post
title: "Notes on nand2tetris"
comments: false
description: MOOC 
keywords: "Learn"
tags:
    - learning
---

If you spend your days clacking on your keyboard and staring and at a screen then please oh please go to <https://www.nand2tetris.org/>

I am gonna be noting down some of the AHA ! moments I had while doing this course which is second favorite moment after bruh moment of course 


### Week 1: 

The first week introduces us to logic gates, I mean I had already leant about em in school and college but never has to care for them outside academics, so it was a fun little refresher 

Logic gates are of course how you can arrange two binary signals on/off high/low 0/1  to perform simple actions like AND (a&b), OR (a^b), NOT (a^) and how you use a combination of them to perform much complex tasks. (Like NAND = NOT- AND) output is opposite of AND

Using these combinations of gates to do cool stuff is combinatorial logic which is the basis of the ALU we design in the course. The Arithmetic and logic unit is of course a core part of our CPU and is nothing but a bunch of combinatorial logic gates

We build simple gates to add, subtraction and multiplication. In the course division is delegated to software but it is actually possible with combinatorial logic <https://electronics.stackexchange.com/questions/256665/how-to-build-a-division-logic-circuit>

It was also really cool to revisit how integer mathematical operations are done with binary values, I was reminded of the first time my teacher blew my mind by converting 3 and 4 to binary and how 11 (2+1) + 100 (4+0+0) in binary gave 111 which actually 7 (4+2+1). The fact that this would hold true for the huge numbers except for the fact that we would need much more bits to represent them.

We also refreshed on multiplexers that uses control line to choose an input out of several inputs, its a special kinda switch, also overflow is used to differ the sign of output to be postitive or negative.

We built a basic ALU takes two 32 bit inputs A & B and 2 control lines. Depending on the value of the control lines, the output will be the addition, subtraction, bitwise AND or bitwise OR of the inputs

![img](http://www.csc.villanova.edu/~mdamian/Past/csc2400fa13/assign/Figs/aluiface.gif)


### Week 2:

Now the circuits we have seen do these operations instantaneously. There is no concept of state or time. But often in the real world time plays an important factor so we come to Sequential logic. Sequential logic circuits have some form of inherent Memory built in amd also have something called clock. In computers we consider time to be discrete. We're going to have what's called a clock, which is some kind of of oscillator going up and down at a certain fixed rate. And, each cycle of the clock we're going to treat as one digital integer time unit. So, once we have this clock, it will basically break up our physical continuous time into a sequence.

Like how a flipflop remembers the input from last time unit and outputs it in the next time unit. We also build a basic 1 bit register using flipflop and a multiplexer with load option based on which we either save tne output from previous execution or load the new bit from input 

![img](https://i.stack.imgur.com/XjmZNm.png)

If we say that load = 0 means it selects the `DFF` and load = 1 means that it selects `in`. You shall see that when load = 0 the circuit repeatedly refreshes the previous value, and load = 1 will read the new value from `in`.

So assume we have a 16bit register in our computer, to read the value of a register we simply probe the output and to write a value to a register we set `in` = `v` we wanna store and assert `load`=1 to load it into the register so that from next cycle probing `out` gives us `v`

Bros like to talk about RAM, it represents how ripped your computer is and says how many pounds and reps it can do without dying. RAM is just a series of n registers with each having an address from `0 to n-1`. At any point in time only one register in a RAM is selected and we select em using the address which has k bits and we see that `k = log2(n)` where n is the number of register and k gives us the number of bits used to represent the address. So if we have 8 registers, then we need log2(8) = 3 bits ranging from 000 (0) to 111 (7). We also have w or word width to represent the width of the register, eg: having 8- 16bit registers means `k=3` and `w=16`.

![img](https://i.imgur.com/hjGNAuo.png)

You are read from and write to RAM using the address of a register. The number of addresses do not affect the access time since at any point in time only one address in a RAM is accessed.

Another memory unit is the counters, In computers it can be used to keep track of instructions executed and kinda say what instruction to do next. It is also a program counter, it has to do three basic operations 

- Reset count = 0
- Next  count ++
- Goto  count = n

Talking about memory we also have ROM which persists its contents after shutdown but is readonly, there is also flash memory that takes the good parts of ram and rom, it is a kind of floating-gate memory that allowed entire sections of memory to be erased quickly and easily in a flash by applying a voltage to a single wire connected to a group of cells. GET IT, FLASH ? 