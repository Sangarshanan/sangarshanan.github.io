---
layout: post
title: "Controlling audio effects on Sonic Pi with OSC"
comments: false
keywords: "Learn"
tags:
    - nerd
    - music-tech
---

Tweaking and changing parameters during Livecoding performance can always be made more intuitive by having ways to change those parameters externally without having to write and edit code everytime something minor has to be altered.

One way i do this is by hooking up Sonic Pi to a MIDI controller and using midi signals to tail the parameters from the keys, knobs and sliders

```rb
live_loop :midi_piano do
  use_real_time
  amp_control = sync "/midi*/knob1"
  n, vel = sync "/midi*/note_on"
  synth :piano, note: n, amp: amp_control, sustain: vel if vel > 0
end
```

But what i can do with MIDI is actually quite limited, for example if i wanna add some interactive components where i can involve the audience in music generation by having ways to respond to things like sensor information and even add some AI aspects to livecoding using sequence generators for drums and melodies then i would have to go to OSC!

OSC is typically transmitted over ethernet and can be used for sensor/gesture-based electronic musical instruments, mapping non musical data to sound, the web interface to sound synthesis and so on, This opens up so much possibilities to build lot of other cool interfaces for Sonic Pi

I am starting off with a basic web service that can tune the fx of the playing loop on the go by sending osc messages to an open socket through [p5js-osc](https://github.com/genekogan/p5js-osc) a project that simply bridge between your Web page and an OSC app or device, in our case Sonic Pi

```js
socket = io.connect('http://127.0.0.1:8081', {
    port: 8081,
    rememberTransport: false
});

socket.on('connect', function() {
    socket.emit('config', {
      server: {
        port: 12004,
        host: '127.0.0.1'
      },
      client: {
        port: 4560,
        host: '127.0.0.1'
     }
   });
});

socket.emit('message', ['/effect/value', "reverb"]);
```

Once we start emitting messages from our web application Sonic Pi just needs to tail those messages by connecting to the osc port with `use_osc` and turning off thread latency with `use_real_time`


```rb
use_osc "localhost", 12004

live_loop :receive_fx do
  use_real_time
  fx = sync "/osc*/effect/value"
  set :effects, fx
  puts fx
end

```

Now if we interact with the web server, there would be messages coming thro to Sonic Pi! But still we haven't done anything with it, after getting the fx value we can send it to another live loop with a default latency and is responsible for playing the sound.

```rb
live_loop :play_notes do
  
  effect = get[:effects] || ["reverb"]
  puts effect[0]
  
  with_fx effect[0] do
    play_pattern_timed chord(:C3, :maj), 0.25
    sleep 0.5
  end
end
```

Now that a pipeline is setup with this silly little goof project, literally too many possibilities open up 🚀

- [Twin Sensor Theremin for Sonic Pi](https://in-thread.sonic-pi.net/t/twin-sensor-theremin-for-sonic-pi/1136)
- [Sonification Stock Market Music](https://in-thread.sonic-pi.net/t/sonification-stock-market-music/7662)
- <https://github.com/mrbombmusic/sonic-pi-drum-rnn-gui>


Some ideas that are worth nothing

- Use gyro & accelerometer sensors from a mobile device to control effects, panning and other types of modulations
- Computer vision run Dance machine that changes tempo based on audience movement
- Sonification of temperature data/ precipitation over the years (Global warming type beat)

and probably a lot more stuff...
