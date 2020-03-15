---
layout: post
title: "Machine Generated Random Numbers"
comments: false
description: random 
keywords: "Learn"
tags:
    - cool stuff
    - nerd
---

So recently I came across this video <https://www.facebook.com/watch/?v=1016305638735073> so if you are too lazy to open the link it basically is a video from the old timey times about a machine called ERNIE or Electronic Random Number Indicator Equipment which is basically a computer that can generate random numbers. But why ? the usecase for ERNIE was to generate lottery ticket numbers but it was marketed as an investment premium bond. 

The principle behind Premium Bonds is that rather than the stake being gambled, as in a usual lottery, it is the interest on the bonds that is distributed by a lottery. The bonds are entered in a monthly prize draw and the government promises to buy them back, on request, for their original price. 

The government pays interest into the bond fund from which a monthly lottery distributes tax-free prizes to bondholders whose ERNIE generated unique numbers are selected randomly

_________

Generating random results from a machine sounda really cool to me cause generally we despise it, we mostly know exactly what we want from a machine. Noone goes to a ticket dispenser and say OOh boy I wonder what I'm gonna get today. But when your usecase is for your machine to be random then you need to introduce randomness

> Ernie introduces randomness into the machine using Neon tubes with High Potential difference on either sides which caused the current to flow, So now these electrons passing through the tube collided with neon atoms and the path was very chaotic, so now that the current is random it wad amplified and converted into pulses and then they calculated the number of pulses per second, maybe around x but this x revolved around a mean so it introduces more randomness they introduced ring counters (A cascaded connection of flip flops, in which the output of last flip flop is connected to input of first flip flop) that counted mod 6, mod 10 or mod 24. 

In the final design nine neon tubes were used to drive nine counters - the ninth counter was arranged to display a value from 0 to 22 to generate a letter (I, O and U were not used)  as part of the overall 8 digit one letter serial numbers. To make sure that a fault in a tube couldn't cause non-random digits to creep in the tubes were doubled up and added together. The outputs were used to drive a teleprinter and the machine produces something like one random number every two or three seconds.

ERNIE is said to have cost £25,000 and it was completed in 1957. It took typically 52 days to complete a draw and was tested by the UK Government Actuary's Department each time to prove its randomness. 

But over time it has evolved and become better, All previous Ernies have used thermal noise to produce random numbers – but Ernie 5 (2019) is powered by quantum technology, with the ability to produce random numbers through light.
This new technology, developed by ID Quantique (IDQ), has allowed Ernie to produce enough random numbers for March’s prize draw in just 12 minutes – more than 40 times faster than the nine hours that Ernie 4 took towards the end of its random number generating career.

_________

So ERNIE is pretty cool but we also have a random number generator in python, how does that work ?

Ok so I went to Python's codebase and looked at random.py <https://github.com/python/cpython/blob/master/Lib/random.py> it seems to be using something called the Mersenne Twister core generator, which sounds like a name for an amusement park ride, also I am not entirely able to understand the code, so I though of going through the history and see how random was written in the very beggining and maybe I might undertstand the code now better, So through github and it's magic I time travelled to random.py written in 1994 <https://github.com/python/cpython/blob/ff03b1ae5bba4d6712563efb7c77ace57dbe6788/Lib/random.py> the good times, when I did not exist. Ooh and this code is really easy to understand. 

So random.py imports whrandom so let's look at <https://github.com/python/cpython/blob/ff03b1ae5b/Lib/whrandom.py>. Ok so this has a random class that implements something called the wichmann hill random number generator

A quick googling tells me that the wichmann hill random number generator consists of three linear congruential generators with different prime moduli, each of which is used to produce a uniformly distributed number between 0 and 1. These are summed, modulo 1, to produce the result. Ok I barely understand, maybe I should look at what the code is doing

```python
def lcg(modulus, a, c, seed):
    """Linear congruential generator."""
    while True:
        seed = (a * seed + c) % modulus
        yield seed
```

So we have three numbers a, c, seed and modulus using which we calculate and the replace seed in the next iteration of the function thus giving us an iterable *generator* of random integers


```python
i = 0
for random_number in lcg(41,20,35,49):
    print(random_number)
    i+=1
    if i==2:
        break
```

first random number : (20 * 49 + 35) % 41 = 31

second random number: (20 * 31 + 35) % 41 = 40 

and so on till you run out of electricity

By adding a simple **yield seed / modulus** to `lcg` we can generate decimals (In the above case it would be 31/41 & 40/41)

Well if you have used python's random then you know that seed is actually used to initialize the random number generator and can be used to customize the start number

Now if we look at python's random, we observe that the seed by default is the current datetime, so it's gotta be unique every time 

```python
class whrandom:
    def __init__(self, *xyz):
        if not xyz:
            import time
            t = int(time.time())
            t, x = divmod(t, 256)
            t, y = divmod(t, 256)
            t, z = divmod(t, 256)
        else:
            x, y, z = xyz
        self.seed(x, y, z)
```

```python
# Set the seed from (x, y, z).

# These must be integers in the range [0, 256).

def seed(self, *xyz):
    if type(xyz) != type(()) or len(xyz) != 3:
        raise (TypeError, '3 seeds required')
    x, y, z = xyz
    if not type(x) == type(y) == type(z) == type(0):
        raise (TypeError, 'seeds must be integers')
    if not 0 <= x < 256 and 0 <= y < 256 and 0 <= z < 256:
        raise (ValueError, 'seeds must be in range(0, 256)')
    self._seed = xyz
    return self._seed
```

```python
# Get the next random number in the range [0.0, 1.0).

def random(self):
    x, y, z = self._seed
    #
    x1, x2 = divmod(x, 177)
    y1, y2 = divmod(y, 176)
    z1, z2 = divmod(z, 178)
    #
    x = (171 * x2 -  2 * x1) % 30269
    y = (172 * y2 - 35 * y1) % 30307
    z = (170 * z2 - 63 * z1) % 30323
    #
    self._seed = x, y, z
    #
    return (x/30269.0 + y/30307.0 + z/30323.0) % 1.0
```

```python
# Get a random number in the range [a, b).

def uniform(self, a, b):
    return a + (b-a) * self.random()

# Get a random integer in the range [a, b] including both end points.

def randint(self, a, b):
    return a + int(self.random() * (b+1-a))

# Choose a random element from a non-empty sequence.

def choice(self, seq):
    return seq[int(self.random() * len(seq))]
```


The function above allows seeds lying between 0,256 and thus has the ability to control the range of the random number it generates  

Seed can be initialized and set according to the time and finding the remainder when divinding time by 256 since seed values must lie between [0, 256)

we can perform operations like

```
random = whrandom()
print(random._seed)
print(random.random())
print(random.uniform(3,4))
print(random.randint(1,10))
print(random.choice([1,2,3,4,5]))
```
 Output 
```
(98, 0, 68)
0.9348645031684898
3.480601271571344
4
3
```

Seed takes the current time lets say 1581514850 and divides it by 256 to get the quotient and remainder which would be (6177792, 98)
in this case 

Now we further take the quotient from the above operation and repeat the division 6177792/256 which would give us (24132, 0) and now for one last time we divide 24132/256 which gives us (94, 68)
 
Our seeds are (98, 0, 68), The three reminders from the divide operations we did 

So now we know our seeds using which we can generate our random numbers with any algorithm we desire, in this case it is a variation of WICHMANN-HILL but it can literally anything else as time acts as our randomizer 

using uniform the generated random number between 0 and 1 is multiplied with a + (b-a) so that we get a decimal between a and b 

randint does on int() to return an integer in a range and choice just chooses a random int lesser than the length of the list to fetch a random index and gets out the list element corresponding to the index   


SO actually if we know the exact time the user ran the random number generator we can find out the numbers that were generated, GOT you random, not so random now are ya 

Below are the links I stole from 


[1] <https://www.i-programmer.info/history/machines/6317-ernie-a-random-number-generator.html>

[2] <https://github.com/python/cpython/blob/master/Lib/random.py>