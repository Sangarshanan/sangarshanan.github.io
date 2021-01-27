---
layout: post
title: "To be or not to be with data structures"
comments: false
description: 
keywords: "Learn"
tags:
    - nerd
---

### Ughhhh Data Structures !? Again ?

No Not Data structures but the cooler cousins, the more probabilistic ones. 

> To be, or not to be

Probabilistic data structures model reality much better since nothing is certain, so if a list has n elements and you insert a gazillion more then you don't really time to count to gazillion and give out the accurate number so you just say its **probably a gazillion** and that's kinda what probabilistic data structures do, which is to provide you with an approximate answer and not a precise one.

You only take approximate answers only when precision is costly or not possible, it is helpful when the data is too freaking big to even hold and even process

### How do you do it ?

So how do you not care about the size? So you need to represent something really big with something small that you can work, maybe a fixed size? I dunno sounds like hash to me 

I am gonna take the scenic route to these data structures cause it's a really good feeling when you solve a problem with what you think is a good solution and that turns out to be really close to a nifty data structure that was designed to solve it.

### Bloom Filters

So here is the problem 

You have a million people signing up to your platform and you wanna identify them by their name, which means no two people can have the same name 

So here is how we can solve the problem

Maybe when a new user signs up you iterate through every name in the platform and check if it already exists and when you are done feel free to grab your walking stick on the way out cause it will be 2077 

Or another way could be with hashing, so for example we have [ a, b, c ] and a wizardly hash of it gives you 101010 and now when a new value come in `d` we calculate this hash again so now since `d` is new the hash of it will be 111011 but if `b` is inserted again then it would bring back the same hash that was inserted once already so we can safely say that this new value already exists, Easy peasy ? well not exactly cause when we scale this up to a gazillion alphabets hash collisions become so common that we cannot be so mucho confidence with our result, we need a tradeoff and hence it is probabilistic.

This is kinda what bloom filters do

We need to choose 3 variables before we start workin on bloom filters 

- N - number of expected elements to be inserted in the filter
- M - the number of bits
- K - the number of hash functions

Given an m and an n, we have a function to choose the optimal value of

```math
 k= (m/n)ln(2)
```
It's a nice property of Bloom filters that you can modify the false positive rate of your filter. A larger filter will have less false positives, and a smaller one more.

We need our hash to be fast since for every new element inserted we need to calculate the k hashes and obviously it has to be collision-free as much as possible, we don't care about security much so we will go with non-cryptographic hashes, i.e My Pokeballs have FNV and MurmurHash courtesy of [https://github.com/flier/pyfasthash](https://github.com/flier/pyfasthash) 

Gonna code up a simple bloom filer with k = 2 and m = 16, since I use 2 hash functions and a 16 bit vector to represent them

<script src="https://gist.github.com/Sangarshanan/5d2bedeec29f48fea1a62aaa33d0fd30.js"></script>

Given a Bloom filter with m bits and k hashing functions, both insertion, and membership testing are O(k). That is, each time you want to add an element to the set or check set membership, you just need to run the element through the k hash functions and add it to the set or check those bits.

Well technically you can run out of bitmaps, in the above case we only have 16 bits and there would come a time when the bitmap contains so many entries that additional entries would create too many false positives

From the point of saturation, any new item will not be added to the saturated bitmap, but to a fresh and larger sub-bitmap (the second level bitmap).

In order to find a value, you'd look it up in the first level bitmap, and if you can't find it there, you'd look it up in the second level bitmap. If you can find it in any of these bitmaps, it is (by a good chance) "known" to the bitmap (false positives may occur as a result of the nature of Bloom filters). If you can't find the value in any of the bitmaps, the bitmap is guaranteed to not have seen it. This, of course, can be expressed as a recursive data structure.

### Hyperloglog

First, we solved the problem of identifying whether a given username is unique or not, now we have another problem and this time it's to identify the number of unique usernames

And as usual, our data is so huge and/or is a never-ending stream of usernames so we can never afford to go the traditional way, This problem is called cardinality estimation and we will be coming up with an algorithm to perform probabilistic counting.

If we have a set that is random but **evenly distributed** then we can actually estimate that there is about `m/x` unique values in the total set where the maximum possible value is m and the smallest value we find is x so for example if we have an evenly distributed set of random numbers between 1 and 10 and the minimum number we find is 3 then we can safely say that there are almost `10/3`  3 unique values in the set, again ** assuming even distribution these numbers might be 3, 6, 9. Oh and also the repetition of numbers won't matter here But this method even when taking into account its even distribution condition is highly inaccurate cause there are cases where there can be a set with only a few distinct values containing an unusually small number or vice versa.

Here is the juice, with a good enough hash function we can take any arbitrary set of data and turn it into one of the sort we need, with evenly distributed and random values.

It was also observed that there are other patterns we can use to estimate the number of unique values, and some of them perform better than recording the minimum value of the hashed elements. We start counting the number of 0 bits at the beginning of the hashed values. It's easy to see that in random data, a sequence of k zero bits will occur once in every 2k elements, on average; Assume that you have a string of length m which consists of {0, 1} with equal probability. What is the probability that it will start with 0, with 2 zeros, with k zeros? It is 1/2, 1/4, and 1/2^k. This means that if you have encountered a string with k zeros, you have approximately looked through 2^k elements. So all we need to do is look for these sequences and record the length of the longest sequence to estimate the total number of unique elements

Again we address the problem with this assumption which is that having evenly distributed numbers from 0 t 2^k-1 is too hard to achieve unless we have a good hashing function eg: `SHA1` hashing gives you values between 0 and 2^160 and with this we can estimate the number of unique elements with the maximum cardinality of k bits by storing only one number of size log(k) bits. This is the basics of probabilistic counting 

But there is another huge problem here : **Variance**

With the above method if the first number we encounter is `00001` then it directly means we have looked at close to 2^4 elements but we have not and this what Variance does  

To solve for variance we can calculate multiple hashes for the same set and average the result but  hashing can be expensive so we use one hash function and divide out the result into buckets and kinda run some averaging function across buckets this way instead of using multiple hashing techniques we can effectively turning one hash function into many

Let’s say that the hash function outputs 32 bits. Then, split up those bits as 5 + 27. Use the first 5 bits to decide which of 2^5=32 buckets you’ll use. Use the remaining 27 bits as the actual hash function

```math

Input:
608942 --> in the 6th bucket, the longest sequence of zeroes is 1
218942 --> in the 2nd bucket, the longest sequence of zeroes is 0
600973 --> in the 6th bucket, the longest sequence of zeroes is now 2
300000 --> in the 3rd bucket, the longest sequence of zeroes is 5

Buckets:
0: 0
1: 0
2: 0
3: 5
4: 0
5: 0
6: 1
7: 0
8: 0
9: 0

Output:
Average of Buckets = (1+5)/10 = 0.6

Cardinality = 2 ^ 0.6 * 10 = 15.1 

// which is super wrong cause our data is small so we usually mutiply this result by α

// where α is the correction factor  

```

As you see, if we weren’t employing buckets we would instead use 5 as the longest sequence of zeroes, which would negatively impact our estimation

This procedure gives us a pretty good estimate - for `m` buckets, the average error is about 1.3/sqrt(m). Thus with 1024 buckets (for 1024 * 5 = 5120 bits, or 640 bytes), we can expect an average error of about 4%; 5 bits per bucket is enough to estimate cardinalities up to 227 per the paper). That's pretty good for less than a kilobyte of memory!

While we’ve got an estimate that’s already pretty good, it’s possible to get a lot better. The author of the original paper Flajolet made the observation that outlying values do a lot to decrease the accuracy of the estimate; by throwing out the largest values before averaging, accuracy can be improved. Specifically, by throwing out the 30% of buckets with the largest values, and averaging only 70% of buckets with the smaller values, accuracy can be improved from 1.30/sqrt(m) to only 1.05/sqrt(m)! That means that our earlier example, with 640 bytes of state and an average error of 4% now has an average error of about 3.2%, with no additional increase in space required. This method is called **SuperLogLog**

There is also **HyperLogLog** that suggests using a different type of averaging, taking the harmonic mean instead of the geometric mean used by SuperLogLog and LogLog

This algorithm is also highly parallelizable


<script src="https://gist.github.com/Sangarshanan/f5280d1c7147916a41a8f357941a45a2.js"></script>

### Count-min

Welp another problem, you now want the frequency of a value in a continuous stream of a gazillion elements, this seems similar to the previous algorithms so we are definitely going to using a hash function and approximating our output, we do this using an algorithm called Count Min

Let us hash every element that comes in like bloom filters do but instead of inverting the bits we increment the value by 1 so that every time the element is seen the bitmap with the location of the hash in incremented, this kinda like in bloom filters will result in collisions but more importantly bloom filters used bitmaps as identifiers of truth, to answer a simple yes or no question but here we want to track out metric with the hash so when we start using multiple hashes we must minimize collision as much as possible 

To do this instead of using an array we add another dimension based on the number of hash functions. We use a M * N matrix where M would be the size of the hash tables and N would be the number of hashing functions, so whenever we see a particular value we hash it N times and increment its position in the all the rows of the matrix

Fetching the Count will be as easy fetching the Min of all the counts cause we can safely say that lesser the count in a row lesser the collisions in the hash for that value, Hence the name Count-Min

<script src="https://gist.github.com/Sangarshanan/4004b62b0a2691e351e0bfdffbcaee20.js"></script>

This is used by databases while query planning to fetch the approximate counts to allocate memory before performing operations like joins, its also used by identify and order the trending & popular pages in websites that have a lot of traffic and approximations are acceptable

I am done. Shoo for now  

### References

- [https://llimllib.github.io/bloomfilter-tutorial/](https://llimllib.github.io/bloomfilter-tutorial/)
- [https://redislabs.com/blog/streaming-analytics-with-probabilistic-data-structures/](https://redislabs.com/blog/streaming-analytics-with-probabilistic-data-structures/)
- [http://blog.notdot.net/2012/09/Dam-Cool-Algorithms-Cardinality-Estimation](http://blog.notdot.net/2012/09/Dam-Cool-Algorithms-Cardinality-Estimation)
- [https://github.com/svpcom/hyperloglog/](https://github.com/svpcom/hyperloglog/)
- [https://odino.org/my-favorite-data-structure-hyperloglog/](https://odino.org/my-favorite-data-structure-hyperloglog/)
- [https://www.moderndescartes.com/essays/hyperloglog/](https://www.moderndescartes.com/essays/hyperloglog/)
- [https://florian.github.io/count-min-sketch/](https://florian.github.io/count-min-sketch/)

Data structures are glamorized a lot that I kinda started to hate them, they are supposed means to solve a problem are not the entire solution, When solving problems we somehow try to conform it to a data structure and that kinda restricts you to the data structures that you know and of course, you never know every data structure that exists and nor do you intend to know. That doesn't mean they arent cool they are just made boring when taught to be memorized without tryna addressing the problems they are trying to solve and boy do I love every dose of that sweet problem-solving dopamine.
