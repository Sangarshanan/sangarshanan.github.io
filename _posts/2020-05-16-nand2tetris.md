---
layout: post
title: "Notes on nand2tetris"
comments: false
description: MOOC 
keywords: "Learn"
header-style: text
tags:
    - learning
---

If you spend your days clacking on your keyboard and staring and at a screen then please oh please go to <https://www.nand2tetris.org/>

I am gonna be noting down some of the AHA ! moments I had while doing this course which is second favorite moment after bruh moment of course 


### Logic gates 1 (Combinatorial): 

The first week introduces us to logic gates, I mean I had already learnt about em in school and college but never had to care for them outside academics, so it was a fun little refresher 

Logic gates are of course how you can arrange two binary signals on/off high/low 0/1  to perform simple actions like AND (a&b), OR (a^b), NOT (a^) and how you use a combination of them to perform much complex tasks. (Like NAND = NOT- AND) output is opposite of AND

Using these combinations of gates to do cool stuff is combinatorial logic which is the basis of the ALU we design in the course. The Arithmetic and logic unit is of course a core part of our CPU and is nothing but a bunch of combinatorial logic gates

We build simple gates to perform addition, subtraction and multiplication. In the course division is delegated to software but it is actually possible with combinatorial logic <https://electronics.stackexchange.com/questions/256665/how-to-build-a-division-logic-circuit>

It was also really cool to revisit how integer mathematical operations are done with binary values, I was reminded of the first time my teacher blew my mind by converting 3 and 4 to binary and how 11 (2+1) + 100 (4+0+0) in binary gave 111 which actually 7 (4+2+1). It's amazing that this would hold true for even huge numbers except for the fact that we would need much more bits to represent them. So the more bits you can store with your hardware, the more complex things you can do, which is incidentally the exact argument I used to get my dad to burn his money for a gaming laptop

We also refreshed on multiplexers that uses control line to choose an input out of several inputs, its a special kinda switch, also overflow is used to differ the sign of output to be postitive or negative.

We built a basic ALU takes two 32 bit inputs A & B and 2 control lines. Depending on the value of the control lines, the output will be the addition, subtraction, bitwise AND or bitwise OR of the inputs

![img](http://www.csc.villanova.edu/~mdamian/Past/csc2400fa13/assign/Figs/aluiface.gif)


### Logic gates 1 (Sequential):

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

Talking about memory we also have ROM which persists its contents after shutdown but is readonly, there is also flash memory that takes the good parts of ram and rom, it is a kind of floating-gate memory that allowed entire sections of memory to be erased quickly and easily "in a flash" by applying a voltage to a single wire connected to a group of cells 


### Machine Language:

One amazing thing about computers is how it can do everything, Where most machines are given a single functionality computers can do many many things. This idea was first formulated by Alan Turing with his Universal Turing Machine and was brought to life by Von Neumann who build a general computing machine wherein the `same Hardware can run different Software programs` and based on the program your operations change and results are formulated. 

Software programs are just a bunch of instructions encoded in binary which tells the hardware what to do, each of these instructions tells what needs to be executed by the hardware. Any fancy program we write in a high level lang gets converted to such instructions. The process of converting the fancy program to machine language is done by the compiler. There are also low level assembly languages which is a just a  human friendly representation of machine language instructions. eg: `01001 101 001 => Add R1 R2` (Add outputs of register1 & 2 )

Registers are the fastest units of memory in our computers and it will be used by our language to store values and in some cases even reference to the address of the main memory where the value is located

So we are gonna build a language is gonna be a low level symbolic language that will be translated to binary with an assembler which we will build later. Lets look at some semantics of our instructions 

<u> A-intruction: Set register A to a value </u> 

eg: `@21 `sets A register to 21 

In binary this is represented as `0value` where 0 is the opcode i.e represents the operation (here it's A) and value is 21 in binary. so its `000000000010101`


<u> C-intruction: Computation that we can store in a certain destination along with a jump directive </u>

here both destination and jump are optional, some examples below 

1) Set D register to -1	

`D=-1`  

2) Set RAM[300] to the value of D register minus 1

`@300` // A=300, Choose RAM[300] (register) to operate on 

`M=D-1` // RAM[300]=D-1

3) If (D-1==0) jump to ROM[56]

`@56` // select A=56

`D-1,JEQ` // JEQ -> jump if equal, so if (D-1==0) goto 56

`dest=comp;jump` is represented in binary as `[1]opcode [11] not used [a c1 c2] comp bits [d1 d2 d3] dest bits [j1 j2 j3] jump directives `  destination can be M, D, M&D registers, NULL etc and jump directives can be JEQ, JGT, JGE, JLT etc.

A Hack program, the symbolic language we write will be a sequence of hack instructions as ones we have defined above which get translated to bytes using the ways we discussed above following which the binary code is run on the computer.  


**IO with Hack Language**

RAM has an area dedicated to display unit called the Screen Memory Map. The physical display is continuosly refreshed from memory map, many times per second. So write code that alters this memory map and you alter the screen which is just pixels that go on/off based on the memory map. For keyboard, we have a 16bit register that is used as a the keyboard memory map where every press of the key is translated to an agreed upon code and sent to the register. We can probe the register to see what key is currently being pressed, its 0 by default.  