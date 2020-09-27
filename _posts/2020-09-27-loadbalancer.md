---
layout: post
title: "'Tis Build-a-Loadbalancer Day"
comments: false
description: Building a loadbalancer
keywords: "Learn"
tags:
    - nerd
    - cool stuff
---

### Introduction


Loadbalancing a way of effectively distributing incoming network traffic across a group of backend servers, so normally in services you have clients and you have server that process the request of your client and when we wanna scale we just add more servers for the clients to get served from, load balancer sits in the middle of this process by accepting requests from clients and routing it to the server, it also does this in a way that optimizes for speed, effective utilization and makes sure that things work even when one of the servers go down.

A very cool analogy I read for this is that of a support center, we are clients whereas the support staff are servers and when we call them the phone line is essentially a loadbalancer cause it has to route our call to one of the available support staff.  

So now that we know the loadbalancer distributes the load, lets talk about how it does it

#### Round Robin

Here, we distribute the load sequentially among servers.
In this strategy we can either assume that all backends have the same processing power or use weights set relative to the processing power

#### Least connections

We prefer the server with the fewest connections to the client. The relative computing capacity of each server is also factored into determining which one has the least connections

#### Least time 

Sends requests to the server selected by a formula that combines the
fastest response time and fewest active connections.


We can also define custom strategies, it all depends on what we wanna do which for me is mostly falling back to defaults. 


### Execution

So our end result should look something like this

<https://hub.docker.com/r/strm/helloworld-http/>

This is a docker-compose file with hello world servers and an nginx loadbalancer to distribute the requests, so we just need to replace that with the one we a new one.

Lets define the steps before actually building it

- Our service is running Huzzah !!
- Hoomans start calling our service, sometimes many and sometimes simultaneously
- For every human that request to use our service we first receive the request start to determine the server that needs to serve the request, we do some `magic()` to get the server that needs to serve the traffic (We discussed some of those magics in the introduction)
- We then serve the traffic through that server, Hooman is happy now !!

Lets actually name our loadbalancer, I hereby decalre thee `bulb` well its BULoadBalancer or bulb depending on whether you are fun at parties.

Now that the naming ceremony is over to be able to do this "magic" we discussed earlier we need metadata on all the servers that are actually serving requests like if its alive, the computing capacity, number of connections to the client and maybe even more.

```python
# Servers have the same computing capacity
class Server:
    url: str # localhost:8080
    alive: bool # Death
    connections: int # A counter
```

In the end we will have a list of servers that can serve the client.

`[Server1, Server2, Server3]` <========>✨ Magic✨ <========> `Route to Server1`

Let's write this magic, well gonna call it `Strategy` for sanity

```python
class Strategy:
    servers = [Server1, Server2, Server3]
    alive_servers = get_alive_servers(servers)
    def round_robin(self):
        robin_goes_round(self.alive_servers)
```

So the last step is to route use the client to the server returned by the output, to do this we are gonna use a simple reverse proxy, its kinda similar to a loadbalancer in the sense that it basically accepts a request from a client, forwards it to a server that can fulfill it, and returns the server’s response to the client. it often makes sense to deploy a reverse proxy when you have just one server cause then you have don't have the need for distributing requests.

<https://www.nginx.com/resources/glossary/reverse-proxy-vs-load-balancer/>

This is an reverse proxy using `twisted`

```python
"""Reverse Proxy."""
from twisted.internet import reactor
from twisted.web import proxy, server

def reverse_proxy(listen_port, proxy_domain, proxy_port, proxy_path=''):
    proxy_path = str.encode(proxy_path)
    site = server.Site(
           proxy.ReverseProxyResource(
               proxy_domain, 
               proxy_port, 
               proxy_path)
            )
    reactor.listenTCP(listen_port, site)
    reactor.run()

reverse_proxy(8080, 'www.google.com', 80)
```
Run this and when you goto localhost:8080 you get redirected to google, Finally !! google running on my localhost. Screw the Internet. 


### Swiper

- <https://www.nginx.com/resources/glossary/load-balancing/>

- <https://kasvith.me/posts/lets-create-a-simple-lb-go/>



