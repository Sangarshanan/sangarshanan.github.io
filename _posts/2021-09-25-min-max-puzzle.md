---
layout: post
title: "A MinMax problem without terms and conditions"
description: "Elegant Algorithms"
keywords: "algorithms"
tags:
    - algorithms that make me cry
---

Found a really [interesting problem](https://www.codewars.com/kata/61211f9d27e72200567dfd3d/train/java) on Codewars today ! Gonna discuss the solution

You got two numbers and you have to find either the `Min` or the `Max` of that number depending on the symbol `<` or `>` you got as input BUT you have to do this without `if / ?: / switch / while / for` which is basically everything conditional

In the end you have a function that goes like this

```math
solve(2, 1, '>') => 2
solve(2, 1, '<') => 1
```

Now we have two conditions that we have to resolve without using conditional statements or Irony

- Is a > b or vice versa
- Should I calculate Min or Max depending on `<` or `>`

We can solve the first problem using Bitshift and the fact that integers are of 32 bits

```java
// if a > b 0 else -1
int value = (a-b) >> 31;
```

If a > b then `a-b` would be positive which would make the value `0` whereas the diff being negative would
make the value `-1` while telling us that actually b > a

We the solve the second we gonna to look at how the symbols in ASCII

```
60 -  <
61 -  =
62 -  >
```

There is an `=` symbol between `<` & `>` so to mimic a - b we just gotta the passed ascii symbol with `=` and do
some math mumbo jumbo to make sure that `>` gives 0 & `<` gives -1. 

The math basically makes sure that 1 returned for `>` gets converted to 0 and -1 remains the same


```java
// if `>` 0 else -1
int operation = (symbol - '=' - 1) / 2
```

Now all that is left is to combine these conditions into a mega condition

- If a > b and Symbol = > then return A (0, 0) Or Vice versa (-1, -1) 
- If a > b and Symbol = < then return B (0, -1) Or vice versa (-1, 0)

Which is actually just an XOR gate where we just produce a 0 when both inputs match else it's 1, now to convert
this boolean into our actual MinMax result we convert our inputs to a List and treat our bool as the Index

```java
public class Puzzle {
    public static int solve(int a, int b, char symbol) {
        /*
        Since integers are 32 bits
        Doing an Right Bit Shift by 31
            - Negative values -> -1 
            - Positive values -> 0
        */
        // if a > b 0 else -1
        int value = (a-b) >> 31;
        // if `>` 0 else -1
        int operation = (c - '=' - 1) / 2 ;
        // if a > b and ` >` return a else b
        int index = (value ^ operation) * -1;
        // Expression that gives us 0 or 1 to pick a or b.
        return new int[]{a, b}[index];
    }
}
```

Neat !

There's a whole lot more on <https://www.codewars.com/kata/61211f9d27e72200567dfd3d/solutions/java>

```java
public class Puzzle {
  public static int solve(int a, int b, char symbol) {
    return a + (b - a & (b - a ^ symbol << 30) >> 31);
  }
}
```