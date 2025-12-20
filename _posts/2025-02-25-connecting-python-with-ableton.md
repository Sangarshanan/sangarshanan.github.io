---
layout: post
title: "Controlling Ableton Live with Python"
comments: false
tags:
    - music-tech
---

I've been messing around with Ableton lately and the first thing I wondered was: **Can I control this thing with Python?**

Turns out, there are two ways to do this. The first (and easiest) is sending MIDI signals to Ableton. The second, which takes a bit more setup, is actually talking to Ableton directly – querying and controlling the interface. This is where OSC comes in, and Live has an API for it.

## Sending MIDI data to Ableton Live

To get Python and Ableton chatting, we'll use "Inter-Application Communication" (IAC). It's basically a virtual cable that lets software share data on the same computer.

Here's the lowdown on setting it up (if you're on a Mac like me):

1.  **Open Audio MIDI Setup:** It's hiding in `/Applications/Utilities`.
2.  **Show MIDI Studio:** Go to `Window` -> `Show MIDI Studio`.
3.  **Enable IAC Driver:**
    *   Double-click the `IAC Driver` icon (it'll probably be grayed out).
    *   Tick the "Device is Online" box.
    *   Add a few MIDI Ports by hitting the `+` button. Think of these as virtual MIDI cables.
    *   Apply the changes.
4.  **Configure Ableton Live:**
    *   In Ableton, find the MIDI track you want to boss around.
    *   Change the "MIDI From" setting from "All Ins" to "IAC Driver (Bus 1)" (or whichever bus you made).
    *   Assign different channels for different MIDI tracks/instruments if you want to control multiple instruments.

Boom! Ableton's now ready to listen to Python's MIDI commands.

We'll use the `rtmidi` library to fling MIDI messages from Python and `python-osc` to get data back from Ableton.

Here's a taste of sending MIDI notes to Ableton:

```python
import time
import rtmidi

midi_out = rtmidi.MidiOut() # Create a MIDI output object
midi_out.open_port(0) # Open the first available MIDI port

def send_notes(pitch=60, repeat=1, sleep_time=0.5):
    """Sends MIDI notes to the specified track."""
    for _ in range(repeat):
        note_on = [0x90, pitch, 112] # note on (channel, pitch, velocity)
        note_off = [0x80, pitch, 0] # note off (channel, pitch, velocity)
        midi_out.send_message(note_on) # Send the note on message
        time.sleep(sleep_time) # Wait for the specified duration
        midi_out.send_message(note_off) # Send the note off message

# Send MIDI i.e Play notes
send_notes(60, 3, 0.75)
send_notes(62, 1, 0.5)
send_notes(68, 4, 0.25)
send_notes(58, 2, 0.5)
```

Go forth and make some noise!

**Generative Melodies with Markov Chains**

Now that we can fire off MIDI notes, how about creating melodies using Markov chains? A Markov chain is a fancy name for a model that predicts the next note based on the current one.

You can find an example in the [`ableton-connect` repository](https://github.com/Sangarshanan/ableton-connect/blob/main/generative_melody.py). The code cooks up a Markov chain from a bunch of training notes and then uses it to whip up a sequence.

Here's the gist of it:

1.  **Define a Markov Chain:** The code makes a dictionary that *is* the Markov chain. The keys are the current notes, and the values are lists of notes that could come next.
2.  **Generate a Sequence:** Starting with a note, the code picks the next note randomly from the list of possible notes in the Markov chain. Repeat, and you've got a sequence!
3.  **Send MIDI Notes:** The generated notes get beamed to Ableton Live using that `send_notes` function we made earlier.

Tweak the training data and Markov chain settings, and you can churn out all sorts of melodies.

## OSC Interface with Ableton Live

To send OSC to Ableton, you'll need to install and enable third-party remote scripts. Check out the details here: [Installing Third-Party Remote Scripts](https://help.ableton.com/hc/en-us/articles/209072009-Installing-third-party-remote-scripts). An absolute legend has already built a remote script that provides an Open Sound Control (OSC) interface to control Ableton Live called [AbletonOSC](https://github.com/ideoforms/AbletonOSC). Once you've done that, select "AbletonOSC" under the Control Surface dropdown in `Preferences > Link / Tempo / MIDI`.

AbletonOSC listens for OSC messages on port 11000 and sends replies on port 11001. Replies go back to the same IP address that sent the message. When you're asking for properties, you can use OSC wildcard patterns. For example, `/live/clip/get/* 0 0` will grab all the properties of track 0, clip 0.

Now you can send OSC commands to boss Ableton around! This basic script sets the tempo, makes a clip, adds notes, and fires it up. The commented-out part pauses all the playing clips.

```python
from pythonosc.udp_client import SimpleUDPClient

ip = "127.0.0.1"
to_ableton = 11000
from_ableton = 11001
client = SimpleUDPClient(ip, to_ableton)

# Set tempo
client.send_message("/live/song/set/tempo", [140])

# Create clip
client.send_message("/live/clip_slot/create_clip", (0, 0, 4))

# Send notes
client.send_message("/live/clip/add/notes", (0, 0,
                                                60, 0.0, 0.25, 64, False,
                                                67, -0.25, 0.5, 32, False))
client.send_message("/live/clip/add/notes", (0, 0,
                                                72, 0.0, 0.25, 64, False,
                                                60, 3.0, 0.5, 32, False))

# Fire up the clip
client.send_message("/live/clip/fire", (0, 0))

# # Stop the clips
# client.send_message("/live/song/stop_all_clips", None)
```

With these MIDI and OSC scripts, I've been able to set up tracks in Live that are fully controlled with code and can be tweaked on the fly by sending OSC signals.
