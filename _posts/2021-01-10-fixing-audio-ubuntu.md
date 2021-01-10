---
layout: post
title: "Aha moments! Fixing sound input/output on Ubuntu"
comments: false
description: 
tags:
    - aha-moments
---

I recently updated to Focal Fossa and there has been a myriad of small fixes that I had to do, ones that hurt were fixing broken virtualenvironments and default Output and Input Sound devices getting reverted to analog audio on reboot.

Being a lazy human being I thought instead of fixing the sounds I would just manually revert it from analog to default whenever I wanted to get on call or listen to music but this slowly crept up and started becoming a pain in the ass to do every time. So I took to the internet...

**~~ Multiple Stackoverflow Answers Later ~~**

Bless `pactl`, I can use it to issue control commands to the PulseAudio sound server. Here is how to update the default source and sinks.

#### Look for Sinks

`pactl list short sinks`

without the `short` decipher which is the right sink 
by looking at the Ports

```math
alsa_output.pci-0000_00_1f.3.analog-stereo
Ports:
	analog-output-speaker: Speakers (priority: 10000, not available)
	analog-output-headphones: Headphones (priority: 9900, available)
```


Choose the default speaker

`pactl set-default-sink 'alsa_output.pci-0000_00_1f.3.analog-stereo' `


#### Look for source 

`pactl list short sources`

without the `short` decipher which is the right source
by looking at the Ports

```math
alsa_input.pci-0000_00_1f.3.analog-stereo
Ports:
	analog-input-internal-mic: Internal Microphone (priority: 8900)
	analog-input-mic: Microphone (priority: 8700, not available)
```

Choose internal microphone

`pactl set-default-source 'alsa_input.pci-0000_00_1f.3.analog-stereo' `


But this does not persist between power cycles so I have to update the pulse config too so imma vim into that bish `sudo vi /etc/pulse/default.pa` and set them defaults

```
### Make some devices default
set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo
set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo
```

The last step is to disable the existing config by renaming the directory `mv ~/.config/pulse ~/.config/pulse.old` and performing the good'ol reboot ritual 

Shoo now