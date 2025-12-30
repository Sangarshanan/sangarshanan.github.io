---
layout: post
title: "One line audiovisuals on the Browser with IBNIZ"
comments: false
keywords: "Learn"
tags:
    - music-tech
---

My last post was about Bytebeat which is so light that i can just embed it onto this static site, I discovered IBNIZ from the same creator which is a virtual machine designed for compact low-level audiovisual programs.

I created a web version of this VM combining multiple existing implementations to make it somewhat like Hydra so that it can be used for livecoding audiovisuals, It's hosted here: **<https://ibniz-live.vercel.app/>**

IBNIZ uses stacks and XOR operations to create a texture using values which can seem a bit random at first but as you play around somethings start to make sense and you can really make crazy visuals by writing just one line of code, It also has a separate context for audio, each with its own stacks and internal registers, every IBNIZ program is implicitly inside a loop that pushes a set of loop variables on the stack on every cycle.

A representation of the Video context (Start with changing gradient as video)

![img](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiG1FFKEfErIZqNLfrf-2mK3xIxSlFBNanQv4SFzLvIm79O2Cub8VAE5TGio9Qlfs_qwxbEq-diV9_xW8wErgY-a8Pcjhcdm9VVDxyPtkHQJJDoND8ekZWvoWO_XstdQwyp1GptbKbt7BQ/s1600/emptyprog-video.png)


And this is how it works for the Audio context (Start with sawtooth wave for audio)

![img](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjbV1W3g1Z7mcF_CzgUoj9JLTurb0-UwuPEzj9Q-WEGpZlKUKjpXqJp2CGPkf5NKkxLU_A1zv1hhgtjRcov6TOt8TC9VK3UBUeaQwos9GBocxNaNaSYFazv3GXwM5fKgKS19EIq3gdRXcE/s1600/emptyprog-audio.png)


- Blogpost: <https://countercomplex.blogspot.com/2011/12/ibniz-hardcore-audiovisual-virtual.html>
- Documentation: <https://github.com/viznut/IBNIZ/blob/master/src/ibniz.txt>
