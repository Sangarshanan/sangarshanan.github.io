---
layout: post
title: "Programming musical constructs with Sonic Pi"
comments: false
keywords: "Learn"
tags:
    - nerd
    - music
---

Recently I have been exploring music quite a lot, partly because working at beatoven.ai has given me a bunch of creative musically inclined colleagues to nerd out with!!! 🥳 Sonic-Pi has been my main tool of choice and i have come to enjoy making sounds with it quite a lot! weekends just fly by when i am toying around with this amazing piece of software.

I am gonna just list some of beatmaking techniques i have been using on Sonic-Pi for my future-self in case i happen to lose all of memory in a freak accident after becoming the MD of a leading indian telecom company.


### Data Structures for Beat Patterns

Very rare for me to care for Data Structures but this is pretty intuitive in itself cause basic beats are nothing but patterns that repeat over time and the simplest way to codify those patterns is through an recursive array


```rb
use_bpm 120

grid1 = [1,0,2,0,   1,0,2,0,   1,0,2,0,   1,0,2,0]

live_loop :met do
  sleep 1
end

live_loop :drum do
  16.times do |index|
    puts index, grid1[index]
    sample :drum_heavy_kick if grid1[index] == 1
    sample :drum_cymbal_pedal if grid1[index] == 2
    
    sleep 0.25
  end
end

live_loop :clap, sync: :met do
  sample :sn_generic, rate: 3, amp: 0.7
  sleep 2
end
```

Somecases your beat is not too complex that i needs an entire array where every beat has to be codifies, most times you already know that maybe your kick should play at the odd beat and snare on the even beat, rather than coding up 0s and 1s in an array, you could do something like this with the `at` function.

```rb
live_loop :drumloop1 do
  at [1, 3, 5] do
    sample :bass_hit_c
  end
  sleep 8
end

live_loop :drumloop do
  at [2, 4, 6] do
    sample :sn_dolf
  end
  sleep 8
end
```

Lets add some hihats and end it with an cymbal to give it some groooveee that makes you move~!!

```rb
use_bpm 120

live_loop :drumloop1 do
  at [1, 3, 5] do
    sample :bass_hit_c
  end
  sleep 8
end

live_loop :drumloop do
  at [2, 4, 6] do
    sample :sn_dolf
  end
  sleep 8
end

live_loop :drumloop3 do
  sleep 8
  sample :drum_cymbal_soft
end

live_loop :hihat do
  sample :drum_cymbal_pedal, amp: 0.2
  sleep 0.5
end
```

Another cool thing that i recently discovered was how [FoxDot](https://github.com/Qirky/FoxDot/blob/master/FoxDot/demo/03_playing_samples.py) sequenced its samples to make beatmaking more intuitive! this idea can be borrowed and used in Sonic Pi as well! it just needs to be a seperate sequencing function for the patterns.

```rb
use_bpm 120

define :drum_pattern do |pattern|
  v = pattern.tick(:pattern)
  puts v
  if v == "x"
    return sample :bd_ada
  elsif v == "o"
    return sample :sn_dolf, amp: 0.5
  elsif v == "-"
    return sample :drum_cymbal_pedal, amp: 0.5
  end
end

live_loop :disco do
  6.times do
    drum_pattern "x-o-"
    sleep 0.5
  end
end
```

I find this more intutive than 0s and 1s in an array cause after using foxdot for sometime i just somehow associate `x` with a `kick` and its also reducing the code written for simple beats, Tho this functions does not emulate the complexity of Foxdot cause you cant change your samples, control speed and other bracket magic! its not too that hard to add all those as well onto your primary pattern function. i like to tune this with my own logic depending on the kinda beat i am looking to cook up.

A way to extend this to control amplitude is demonstrated over on the [sonic-pi server](https://in-thread.sonic-pi.net/t/rhythm-notation-for-tuplets-with-amplitude/5368) where you use integers rather than characters which in-turn control the amplitude


```rb
use_bpm 120

live_loop :closedHiHat do
  pattern = "8--6--6--2468--6--6--6--".ring
  pattern.length.times do
    sample :drum_cymbal_closed, amp: (pattern[look].to_f / 9), sustain: 0.2 if (pattern[tick] != "-")
    sleep 4/pattern.length.to_f
  end
end
```

Case conditions are another way to codify pattern and define loops

```rb
live_loop :drum do
  #stop
  a = [1, 1, 1, 1, 2].choose
  case a
  when 0
    sample :drum_heavy_kick
    sleep 1
    sample :drum_cymbal_pedal
  when 1
    sample :bd_ada
    sleep 1
    sample :drum_cymbal_pedal
    
  when 2
    sample :bd_haus
    sleep 1
    sample :drum_cymbal_soft
  end
end
```


Might add more content here as i discover it.


btw I got all of my sonic pi stuff up on github <https://github.com/sangarshanan/sonic-pi-beats>

