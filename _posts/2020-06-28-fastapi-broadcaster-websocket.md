---
layout: post
title: "Realtime channels with FastAPI + Broadcaster"
comments: false
description: Using Websockets and async ecosystem
keywords: "Learn"
tags:
    - nerd
    - cool stuff
---

Hey there little stinker

Websockets are awesome, just learnt that before websockets people were polling (eww). Well actually polling helps when you know the exact time interval of your refresh But we are gonna be the cool realtime streamers. 

Websockets allow full-duplex, bidirectional connections between a client and a server over the web with a single TCP connection (A protocol for sending and receiving packets of data across IPs in a reliable way, simply by acknowledgement)

We are gonna be using [Fastapi](https://github.com/tiangolo/fastapi) and [Starlette](https://github.com/encode/starlette) to define Websocket endpoint and [Broadcaster](https://github.com/encode/broadcaster) to publish messages to this websocket. Others can just subscribe to the websocket endpoint to receive the published messages in real time 

So this is what my API looks like, there is just one endpoint to publish messages to a channel (lebowski). Now the goal is to have a websocket that hoomans/robots can subscribe to follow the updates to lebowski in real time.

```python
import json
from fastapi import FastAPI
from pydantic import BaseModel

class Publish(BaseModel):
    channel: str = "lebowski"
    message: str

app = FastAPI()

@app.post("/push")
async def push_message(publish: Publish):
    return Publish(channel =publish.channel, 
    message =json.dumps(publish.message))
```

We are gonna use broadcaster and Starlette to define a websocket endpoint

With starlette we can use WebSocketEndpoint and use it to create a WebsocketRoute, WebSocketEndpoint has three overridable methods for handling specific ASGI websocket message types: on_connect, on_receive, on_disconnect. 

```python
class Echo(WebSocketEndpoint):
    encoding = "text"
    async def on_connect(self, websocket):
        await websocket.accept()
    async def on_receive(self, websocket, data):
        await websocket.send_text(f"Message text was: {data}")
    async def on_disconnect(self, websocket, close_code):
        pass

routes = [WebSocketRoute("/ws", Echo)]
```
This is a simple echo websocket that send back what it receives. But I am not worrying about all this I am using broadcaster. With broadcaster we can define a simple broadcasting API onto a number of different backend services like Redis PUB/SUB, Kafka, Postgres LISTEN/NOTIFY or an in-memory one.

```python
from starlette.concurrency import run_until_first_complete
from starlette.routing import WebSocketRoute

from broadcaster import Broadcast

broadcast = Broadcast("postgresql://postgres@localhost/test")

async def events_ws(websocket):
    await websocket.accept()
    await run_until_first_complete(
        (events_ws_receiver, {"websocket": websocket}),
        (events_ws_sender, {"websocket": websocket}),
    )


async def events_ws_receiver(websocket):
    async for message in websocket.iter_text():
        await broadcast.publish(channel="events", message=message)


async def events_ws_sender(websocket):
    async with broadcast.subscribe(channel="events") as subscriber:
        async for event in subscriber:
            await websocket.send_text(event.message)
routes = [
    WebSocketRoute("/events", events_ws, name="events_ws"),
]
```

We have defined two async functions to receive and publish messages and passed it to a starlette WebSocketRoute. Used Postgres as a backend for the broadcaster.

Now that we have defined a websocket route with broadcaster, lets just add it FastAPI and seal the deal

```python
from fastapi import FastAPI

app = FastAPI(
    routes=routes, 
    on_startup=[broadcast.connect],
    on_shutdown=[broadcast.disconnect],
)

@app.post("/push")
async def push_message(publish: Publish):
    await broadcast.publish(publish.channel, 
    json.dumps(publish.message))
    return Publish(channel =publish.channel, 
    message =json.dumps(publish.message))
```

I have added the websocket route to the FastAPI app and am publishing to the channel on every call to the API.

Now to test things I am writing a dummy subscriber to listen to the broadcast (With the API is running on port 1234)

```python
import json
import asyncio
import websockets
from websockets.exceptions import ConnectionClosed

async def connect(uri):
    async with websockets.connect(uri) as websocket:
        print("Connected..")
        while True:
            message = await websocket.recv()
            action = json.loads(message)
            print(action)

async def hello():
    uri = "ws://localhost:1234/events"
    try:
        await connect(uri)
    except ConnectionClosed:
        await asyncio.sleep(3)
        print("Not able to connect.. Retying in 3 seconds")
        await connect(uri)

asyncio.get_event_loop().run_until_complete(hello())
```

That's it :) In action below 👇

![alt text](/img/cmd_websocket.png)


Ok lastly, FastAPI is awesome and I have been using a lot lately. It's powerful, easy to learn and the async community powering the whole ecosystem makes me wanna cry happy tears 😭

:wq