---
layout: post
title: "Everything bagel on shader park"
comments: false
keywords: "Learn"
tags:
    - nerd
---


I discovered [shaderpark](https://shaderpark.com) and thought it was seriously neat! In the past i have tried exploring shader programming for random projects cause i was anyway exploring livecoding music and they kinda go together but i was totally overwhelmed by the OpenGL like libraries cause they looked so complex, i stuck with p5js to make small projects and that's it but now after looking at shaderpark and the ease at which it abstracts some of the things i feel like its gonna be a lot of fun using it for visual livecoding!!

I do not know why but I really wanted to make the Bagel from Everything Everywhere All at Once


```js
// Rotate so the Bagel is facing me and not up
rotateX(Math.PI/2);
// Space cause duh
let s = getSpace();
// Black
color(0,0,0)
// One Donut
torus(0.7, 0.4 + 0.1*noise(s*2.0 + time));
// To mix the geometries
mixGeo(0.9)
// Some Shiny
reflectiveColor(vec3(.3))
// Another Donut
torus(0.7, 0.9 + 0.1*noise(s*2.0));

// & Behold
// The modern day symbol of Nihilsm: a fucking black bagel
```

<p align="left">
<iframe class="" rel="nofollow" style="height: 800px; width:1000px;" 
      src="https://shaderpark.com/embed/-NlYYf0va-e5JONN7Vub"></iframe>
</p>

Another sick tool i use as a backdrop for the livecoding videos i record is <https://hydra.ojack.xyz/>
