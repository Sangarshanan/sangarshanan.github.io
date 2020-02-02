---
layout: post
title: "Machine Generated Random Numbers"
comments: false
description: random 
keywords: "Learn"
---


So recently I came across this video <https://www.facebook.com/watch/?v=1016305638735073> so if you are too lazy to open the link it basically is a video from the old timey times about a machine called ERNIE or Electronic Random Number Indicator Equipment which is basically a computer that can generate random numbers. But why ? the usecase for ERNIE was to generate lottery ticket numbers but it was marketed as an investment premium bond. The principle behind Premium Bonds is that rather than the stake being gambled, as in a usual lottery, it is the interest on the bonds that is distributed by a lottery. The bonds are entered in a monthly prize draw and the government promises to buy them back, on request, for their original price. 

The government pays interest into the bond fund from which a monthly lottery distributes tax-free prizes to bondholders whose ERNIE generated unique numbers are selected randomly

Generating random results from a machine sounda really cool to me cause generally we despise it, we mostly know exactly what we want from a machine. Noone goes to a ticket dispenser and say OOh boy I wonder what I'm gonna get today. But when your usecase is for your machine to be random then you need to introduce randomness

Ernie did that using Neon tubes with High Potential difference on either sides which caused the curremt to flow, So now these electrons passing through the tube collided with neon atoms and the path was very chaotic, so now that the current is random it wad amplified and converted into pulses and then they calculated the number of pulses per second, maybe around x but this x revolved around a mean so it introduces more randomness they introduced ring counters (A cascaded connection of flip flops, in which the output of last flip flop is connected to input of first flip flop) that counted mod 6, mod 10 or mod 24. 

In the final design nine neon tubes were used to drive nine counters - the ninth counter was arranged to display a value from 0 to 22 to generate a letter (I, O and U were not used)  as part of the overall 8 digit one letter serial numbers. To make sure that a fault in a tube couldn't cause non-random digits to creep in the tubes were doubled up and added together. The outputs were used to drive a teleprinter and the machine produces something like one random number every two or three seconds.

ERNIE is said to have cost £25,000 and it was completed in 1957. It took typically 52 days to complete a draw and was tested by the UK Government Actuary's Department each time to prove its randomness. 

But over time it has evolved and become better, All previous Ernies have used thermal noise to produce random numbers – but Ernie 5 (2019) is powered by quantum technology, with the ability to produce random numbers through light.
This new technology, developed by ID Quantique (IDQ), has allowed Ernie to produce enough random numbers for March’s prize draw in just 12 minutes – more than 40 times faster than the nine hours that Ernie 4 took towards the end of its random number generating career.

So ERNIE is pretty cool but we also have a random number generator in python, how does that work ?


<https://www.i-programmer.info/history/machines/6317-ernie-a-random-number-generator.html>