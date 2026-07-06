---
layout: post
title: "On Recommendation systems 💿"
comments: false
keywords: "Learn"
tags:
    - music-tech
---


For the past couple months at [Deezer](https://www.deezer.com/) I have gotten to explore a fair bit of Recommender systems, I have had some [strong opinions](https://sangarshanan.com/2025/10/05/expanding-music/) about them in the past and it was quite interesting to see how they actually work at an company that heavily works on these recommendations.

My favorite thing about these Recommender systems is the fact that the first thing we learn about them, as a rather historical exercise is the GroupLens collaborative filtering, which is if I am being honest not too far off from how we do things currently. We can try to replace user based algorithms with item based algorithms or combine them with a weighted averages. And this works quite well until we reach a scale threshold where modelling all users or all items maxes out our compute poor machines so we simply get into latent space, identifying dimensions that group similar users and similar items, Here comes the SVD based collaborative filtering.

This was back in the early 2000s and to be honest even today, when everyone wants make transformer sandwiches and LLM Paninis, the crux of production grade recommender systems is still, simple matrix factorization.

We do inject some smart logic here and there, I found Funk SVD pretty cool, and how it dealt with sparsity in the data by literally just initializing it with random values rather than making it zero and approximating using SGD. Very gangster indeed. Once the era of more and more data began we began fixing this sparsity with implicit signals like users like clicks, play, intent to download and all the other shit product managers go on about.

And then comes the Neural network era, We have: Embarrassingly Shallow Autoencoder and if it isn't obvious from the name it has no hidden layers and gives us a very nice closed-form solution and there is Collaborative Denoising Autoencoder which  very interestingly when initialized with linear activation and no bias collapsed into an SVD. There is also neural CF which decided that dot product for similarity isnt good enough and put a neural network to capture non linear relations but at lower epochs it did not really beat existing benchmarks and so the complexity that these approaches brought was not really justified by performance.

Of course when we get into specifics there are transformers giving us sequential recommendation and people do plug in LLMs here and then for sprinkled hallucinations, But the fact is the industry is still running on linear algebra and that just really makes me happy.

> My research at Deezer has been focused on embedding aggregation, the stability of centroids & I have also been exploring alternate representations and the Geometry of SVD. Hopefully I will write about this after a long hard rumination session that is due post my intern days in Paris. SO there will be a RecSys part 2 soon but until then I run back to buying baguettes.
