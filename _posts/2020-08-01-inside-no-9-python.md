---
layout: post
title: "Looking inside Python 3.9"
comments: false
description: Europython 2020 
keywords: "Project"
header-style: text
tags:
    - life

---

| ![img](https://n4mb3rs.com/wp-content/uploads/2015/05/inside_number_91.jpg) | 
|:--:| 
| *This image has nothing to do with Python, it's just a really cool BBC show* |


Dictionaries are awesome, I tend to use em for everything. There are a lotta times, if not for dictionaries I would have had to write 100s of if-elif-else statements but I've sometimes felt that merging dictionaries are a pain in the ass

So, one way do to it is of-course the `.update` 

```python
d1 = {'a': 1}
d2 = {'b': 2}
d1.update(d2)
```

But this is an in-place operation, ughh so I have to create a new variable just for this 

```python
new_dict = d1.copy()
new_dict.update(d2)
```

But I don't wanna live in constant fear of accidentally updating my dictionary inplace, so I try to do the unpacking trick that multiple "experts" on stackoverflow suggested.

```
new_dict = {**d1, **d2}
```

Phew so this is much better but it's quite ugly and unreadable for someone new, the operation we are tryna perform isn't very obvious from the code and so its "unpythonic". Also this fails for dict subclasses like defaultdict cause they have an incompatible `__init__` method.

There are also other ways like using Collections.ChainMap ```new_dict = ChainMap(d1, d2)``` which again unpacks the dict so does not work for certain subclasses of dict, we
can also do ```dict(d1, **d2)``` (Only works when keywords are strings)


So let's get this PEP

### PEP 584 which adds Union Operators To dictionaries

<https://www.python.org/dev/peps/pep-0584>

> This PEP proposes adding merge `(|)` and update `(|=)` operators to the built-in dict class.


![img](https://pbs.twimg.com/media/EeVsvjtUYAIHsr8?format=png&name=small)

Dict union will return a new dict consisting of the left operand merged with the right operand, each of which must be a dict (or an instance of a dict subclass). If a key appears in both operands, the last-seen value (i.e. that from the right-hand operand) wins:


```python
>>> d = {'spam': 1, 'eggs': 2, 'cheese': 3}
>>> e = {'cheese': 'cheddar', 'aardvark': 'Ethel'}
>>> d | e
{'spam': 1, 'eggs': 2, 'cheese': 'cheddar', 'aardvark': 'Ethel'}
>>> e | d
{'aardvark': 'Ethel', 'spam': 1, 'eggs': 2, 'cheese': 3}
```

The augmented assignment version operates in-place:

```python
>>> d |= e
>>> d
{'spam': 1, 'eggs': 2, 'cheese': 'cheddar', 'aardvark': 'Ethel'}
```

So this augmented assignment behaves identically to the update method called with a single positional argument, so it also accepts anything implementing the Mapping protocol (more specifically, anything with the keys and __getitem__ methods) or iterables of key-value pairs.

so we can do `d |= [('b', 2)]` which updates d inplace with `{'b':2}` this does not work with the normal `|` operator and would return `TypeError :can only merge dict (not "list") to dict`

Well as you can see, this union is not commutative `(d | e != e | d)`

Also repeated dict unions are inefficient as it creates a lot of temp mapping, so it's better to loop with in-place merging when you a lot of dictionaries

```python
new = {}
for d in many_dicts:
    new |= d
```

Yeeee time for the implementation

```python
class SpecialSauce(dict):
    def __or__(self, other):
        if not isinstance(other, dict):
            return NotImplemented
        new = dict(self)
        new.update(other)
        return new

    def __ror__(self, other):
        if not isinstance(other, dict):
            return NotImplemented
        new = dict(other)
        new.update(self)
        return new

    def __ior__(self, other):
        dict.update(self, other)
        return self

d1 = SpecialSauce({"a": 1})
d2 = SpecialSauce({"b": 2})

print(d1 | d2)

d1 |= d2

print(d1)
```

This was my favorite change, so I took the time to look at the whole PEP and oh my it was quite fun to read... Note to self: I should go through some PEPs over the weekend, they are really well written and super easy to understand and appreciate

So another cool thing is that with PEP 585, for type annotations we don't have to import List, dict and other built-in collection types from Typing anymore

Also there is a new `zoneinfo` module 

```python
from zoneinfo import ZoneInfo
from datetime import datetime
dt = datetime(2020, 10, 31, 12, tzinfo=ZoneInfo("America/Los_Angeles"))
```

### For Forgetful eyes only 

To get and play with the latest python from source 

Head on to Releases eg: <https://www.python.org/downloads/release/python-390b5/>
and download 

Unzip the source (obviously) `tar zxvf Python-3.9.0b5.tgz`

Configure `./configure --enable-optimizations`

Install `sudo make altinstall`

altinstall to keep the default `/usr/bin/python` safe

---
**Note to self:**

Use your brain before running something on sudo and don't break your environment again you idiot

---
