---
layout: post
title: "Behind your Web Application (WSGI + Web server)"
comments: false
description: Async 
keywords: "Learn"
---


When I started writing simple flask web applications back in college I did not actually undertand what was happening in the back when I run the flask application

So when I run `` python app.py `` , this pops up

```
 * Serving Flask app "somename"
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
```

Now I am able to interact with the applications by sending requests and getting a responses but how am I able to that... I did not do anything to make that happen.. I just wrote the logic and Flask did it for me and I was able to get stuff done really fast 

It's almost similar even when you look at other frameworks like Django

Django provides tons of stuff out of the box for you like routing, views, templates, authentication, middleware and a whole lot more with a very rich documentation so that you are always in your comfort zone. And with a huge community any issue I faced with Django was one stackoverflow answer away

These frameworks wrap everthing up so you just write in your logic and you are able to send requests and handle responses 

By running your application and sending HTTP requests, you realise 3 things happening in the HTTP flow  

1. You open a TCP connection: (In my case it's the localhost) The TCP connection is used to send a request, or several, and receive an answer. The client may open a new connection, reuse an existing connection, or open several TCP connections to the servers

2. Send an HTTP request message with your application

```
GET / HTTP/1.1
Host: developer.mozilla.org
Accept-Language: fr


```

3. You get a response from the server which you process with your application

```
HTTP/1.1 200 OK
Date: Sat, 09 Oct 2010 14:28:02 GMT
Server: Apache
Last-Modified: Tue, 01 Dec 2009 20:18:22 GMT
ETag: "51142bc1-7449-479b075b2891b"
Accept-Ranges: bytes
Content-Length: 29769
Content-Type: text/html

<!DOCTYPE html... (here comes the 29769 bytes of the requested web page)
``` 
Now you close or reuse the connection 

But then how the hell do these python framework handle HTTP requests ? Cause it seems like magic... and I would love to learn a trick or two so let's break it down :D

Well maybe your site is static and you have all your files saved  

Then for every request you already have corresponding static file as a reponse... awesome this is really fast, you could do tons of caching techniques and it's all really easy and straightforward but I mean it's static which means that you have to manually go and edit the html files every time 

To solve this issue arose the Common gateway interface which invokes a script that dynamically generates the web page


---
*Common Gateway Interface (CGI) offers a standard protocol for web servers to execute programs that execute like console applications (also called command-line interface programs) running on a server that generates web pages dynamically*

---

The HTTP request that comes in breaks down into ENV variables which act as input and invokes a script which acts as a function and you get your output as an STDOUT... So if you just print hello world, it would be yout http response 

As cool and simple as all this sounds, you can't afford to run the script every time you get a request 

So we need a seperate out the web server and the python application 

Enter WSGI 

Or as the cool people call it Web server gateway interface 

WSGI can be implemented with a simple function and every time there is a request we just call the function instaead of running an entire script 

---

*It is a specification that describes how a web server communicates with web applications, and how web applications can be chained together to process one request*

*WSGI is not a server, a python module, a framework, an API or any kind of software. It is just an interface specification by which server and application communicate*

---

Well this means freedom cause we don't really need to worry about web servers like nginx or apache given that they understood this common interface and we could easily switch anytime we wanted to

Also there is a really cool article comparing these two web servers <https://serverguy.com/comparison/apache-vs-nginx/>

And if you wanted to build your own framework then you don't have to know a whole lot of HTTP and instead build something that implements this simple function (The one below is Gunicorn)

```
def app(environ, start_response):
    data = b"Hello, World!\n"
    start_response("200 OK", [
        ("Content-Type", "text/plain"),
        ("Content-Length", str(len(data)))
    ])
    return iter([data])
```

This function take two arguments 

- start_response: This is invoked with a status code, headers and an iterable data that you wanna send back (here it's the generic hello world) 

- environ: Well this is dictionary with some information like REQUEST_METHOD, PATH_INFO, SERVER_PROTOCOL etc

WSGI servers like Gunicorn are designed to handle many requests concurrently. Frameworks are not made to process thousands of requests and determine how to best route them from the server. They can also communicate with multiple web servers and keep multiple processes of the web application running. They can also async (Bjoern which is actually faster but not compatible with HTTP/1.1)

---
Gunicorn describes itself as a Pre-fork web server which means that a master creates forks which handle each request. A fork is a completely separate process and the "pre" part actually means that worker processes are created in advance, so that time is not wasted forking only when a worker is needed

---

A very commonly used combo includes Nginx + Gunicorn + Django where Gunicorn acts as a middleware between nginx and the Django

![img](https://rukbottoland.com/media/images/arquitectura-django-gunicorn-nginx-supervisor.jpg)

But now with Gunicorn why the hell do we need Nginx... seems unnecessary to me 

Well with Gunicorn Ngnix acts as a reverse proxy server which can be used to provide load balancing, provide web acceleration through caching or compressing inbound and outbound data, and provide an extra layer of security by intercepting requests headed for back-end servers and also gunicorn is designed to be an application server that sits behind a reverse proxy server that handles load balancing, caching, and preventing direct access to internal resources.

Actually python comes with it's own built-in web server that provides standard GET and HEAD request handlers. You can use this to turn any directory in your system into your web server directory. I have actually used this to share code and stuff with my peers and it's pretty handy <3

Now to reaffirm the fact that i have learnt somethings let's write sum fresh code with Sockets... ughh...Now I'm glad I don't have to do this everytime I write a webapp


Now let's run this code to start a simple web server on port 8000

```
import socket
HOST = '' ## Symbolic name meaning all available interfaces
PORT = 8000 ## Port 8000

'''
AF_INET is an address family that is used to designate the 
type of addresses that your socket can communicate with (in this case, Internet Protocol v4 addresses). 

SOCK_STREAM is a constant indicating the type of socket (TCP),
'''
listen_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

'''
Set the value of the given socket option
When retrieving a socket option, or setting it, 
you specify the option name as well as the level. When level = SOL_SOCKET, 
the item will be searched for in the socket itself.

For example, suppose we want to set the socket option 
to reuse the address to 1 (on/true),
we pass in the "level" SOL_SOCKET and the value we want it set to.

This will set the SO_REUSEADDR in my socket to 1.
'''

listen_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

## Bind to the host and port
listen_socket.bind((HOST, PORT))

## Listen to the host/port
listen_socket.listen(1)
print(f'Serving your very own HTTP on port {PORT} ...')

while True:
    client_connection, client_address = listen_socket.accept()
    """
    The recv() function receives data on a socket 
    with descriptor socket and stores it in a buffer. 
    """
    request_data = client_connection.recv(1024)
    print(request_data.decode('utf-8')) ## Decode the data assuming UTF=8 Endoding

    http_response = b"""\
HTTP/1.1 200 OK

Sample Response to be parsed!
"""
    ## Send a response and close the connection
    client_connection.sendall(http_response)
    client_connection.close()

``` 

Run the file.. I've saved it as webserver.py 

```
$ python webserver.py                                                                                                                 
Serving your very own HTTP on port 8888 ...
```

Now let's ```curl -v http://localhost:8000/```

```

*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8000 (#0)
> GET / HTTP/1.1
> Host: localhost:8000
> User-Agent: curl/7.58.0
> Accept: */*
> 
< HTTP/1.1 200 OK
* no chunk, no close, no size. Assume close to signal end
< 
Sample Response to be parsed!
* Closing connection 0
```

Maybe also try ```telnet localhost 8000```

```
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.

HTTP/1.1 200 OK

Sample Response to be parsed!
Connection closed by foreign host.

```

There you go a simple web server to send requests and get responses

Now you can write your own web framework to interact with this web server and you would have essentially written your own application from scratch 

Essentially you get parsed responses for processing / storing or whatever it is you are into  

```
import requests
r = requests.get('http://127.0.0.1:8000/') 
print(r.content) 
```

Different web frameworks communicate with web servers in different ways  

In pyramid you have an application object that comes back from make

```
from pyramid.config import Configurator
from pyramid.response import Response


def hello_world(request):
    return Response(
        'Hello world from Pyramid!\n',
        content_type='text/plain',
    )

config = Configurator()
config.add_route('hello', '/hello')
config.add_view(hello_world, route_name='hello')
app = config.make_wsgi_app()

```

Flask is actually build around Werkzeug which is a WSGI web application library and Flask wraps Werkzeug, using it to handle the details of WSGI while providing more structure and patterns for defining powerful applications. In flask we actually define this as the app that we use as a decorator for our views and it's got routing and other functionalities built into it 

```
from flask import Flask
from flask import Response
flask_app = Flask('flaskapp')


@flask_app.route('/hello')
def hello_world():
    return Response(
        'Hello world from Flask!\n',
        mimetype='text/plain'
    )

app = flask_app.wsgi_app
```

 
Contains stolen content from  
 <https://github.com/rspivak/lsbaws>
 <https://www.youtube.com/watch?v=WqrCnVAkLIo>

You scrolled to the end :)