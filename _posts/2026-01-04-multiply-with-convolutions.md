---
layout: post
title: "Multiplications with Convolution & FFT"
comments: false
keywords: "Learn"
tags:
    - nerd
---

I have been revisiting a lot of concepts related to FFTs and convolutions recently as part of my coursework, and interestingly, I ran into something so fundamental that I surprisingly hadn't encountered before. It's **the convolution theorem**, which says that the convolution of two functions (or signals) is the product of their Fourier transforms. So, **convolution in the time domain is the same as multiplication in the frequency domain**, which means we can use this for something as basic as calculating the product of two random integers, rather than the repeated addition method we are taught in school.

This is how we are taught to multiply with pen and paper if we want multiply 23 by 17:

```math
23 x 17
23 + 23 + 23 + ... 17 times

23
x 17
-----
1 6 1
2 3 
-----
391
```

We can write this in Python like this:

```python
def multiply_by_add(a, b):
    if a == 0 or b == 0:
        return 0
    
    # Convert to strings to access digits
    str_a = str(a)
    str_b = str(b)
    len_a = len(str_a)
    len_b = len(str_b)
    
    # Result array - maximum length is len_a + len_b
    result = [0] * (len_a + len_b)
    
    # Multiply each digit of b with each digit of a
    for i in range(len_b - 1, -1, -1):
        digit_b = int(str_b[i])
        
        for j in range(len_a - 1, -1, -1):
            digit_a = int(str_a[j])
            
            # Multiply two single digits using repeated addition
            product = 0
            for _ in range(digit_b):
                product += digit_a
            
            # Position in result array
            pos = (len_b - 1 - i) + (len_a - 1 - j)
            
            # Add product to current position
            result[pos] += product
    
    # Handle carries
    carry = 0
    for i in range(len(result)):
        total = result[i] + carry
        result[i] = total % 10
        carry = total // 10
    
    # Remove leading zeros
    while len(result) > 1 and result[-1] == 0:
        result.pop()
    
    # Convert to integer
    return int(''.join(map(str, result[::-1])))
```

Here we multiply every digit of a by every digit of b, so if there are 1,000 digits each, then we would need 1,000,000 operations, or $O(n^2)$.

This is going to get really slow as the number of digits goes up. So instead of thinking about multiplication as repeated addition, let's, for a second, think of numbers as polynomials.

```math
Example: 123 × 456

123 = 1×10² + 2×10¹ + 3×10⁰ = 3 + 2x + 1x² [3,2,1]
456 = 4×10² + 5×10¹ + 6×10⁰ = 6 + 5x + 4x² [6,5,4]

Where x = 10 (our base)
```

Now we know that the multiplication of two 3-digit numbers can have a maximum of 6 digits in the result, so we can pad our integers to that length as we will run them through a convolution—just like we always do padding in CNNs.

```math
[3, 2, 1] → [3, 2, 1, 0, 0, 0] 
[6, 5, 4] → [6, 5, 4, 0, 0, 0]
```

Now we calculate the FFT of the polynomials to get the frequency values in the complex plane, and then run our convolution operation, which, being a pointwise multiplication, is much faster. Once that is done, we do an inverse FFT to go back to the real plane.

Each frequency bin is independent; there is no summation across time.

> So, instead of convolving in the time domain, we multiply in the frequency domain, which is much faster: $O(n \log n)$.

```python
>>  digits_a = [3, 2, 1, 0, 0, 0] 
>>  digits_b = [6, 5, 4, 0, 0, 0]
>>  fft_a = np.fft.fft(digits_a)
>>  fft_b = np.fft.fft(digits_b)
>>  fft_result = fft_a * fft_b
>>  result = np.fft.ifft(fft_result).real
>>  result = np.round(result).astype(int)
array([18, 27, 28, 13,  4,  0])
```

The inverse FFT reconstructs the final polynomial coefficients, which can be written as $18 + 27x + 28x^2 + 13x^3 + 4x^4$ with base 10, giving us 56088, which is exactly $123 \times 456$.

Here is the full Python method:

```python
def fft_multiply(a, b):
    # Convert integers to digit arrays
    str_a, str_b = str(a), str(b)
    digits_a = [int(d) for d in str_a[::-1]]
    digits_b = [int(d) for d in str_b[::-1]]

    print(digits_a, digits_b)
    
    # Pad to power of 2 for efficient FFT
    n = len(digits_a) + len(digits_b)
    size = 2 ** int(np.ceil(np.log2(n)))
    
    # Zero-pad
    digits_a += [0] * (size - len(digits_a))
    digits_b += [0] * (size - len(digits_b))
    
    # Perform convolution via FFT
    fft_a = np.fft.fft(digits_a)
    fft_b = np.fft.fft(digits_b)
    fft_result = fft_a * fft_b
    result = np.fft.ifft(fft_result).real
    
    # Handle carries
    result = np.round(result).astype(int)
    carry = 0
    final_digits = []
    
    for digit in result:
        total = digit + carry
        final_digits.append(total % 10)
        carry = total // 10
    
    while carry:
        final_digits.append(carry % 10)
        carry //= 10
    
    # Remove leading zeros and convert back to integer
    while len(final_digits) > 1 and final_digits[-1] == 0:
        final_digits.pop()
    
    return int(''.join(map(str, final_digits[::-1])))
```

Here, the total complexity is that of the FFT operation, which is $O(n \log n)$. This means for 1,000 digits, there will be about 10,000 operations—significantly fewer than traditional addition.

Benchmarking shows us the real speedup!


```python
"""
Digits     FFT speed       Addition Speed     Speedup
------------------------------------------------------
100        0.5265          5.4833             10.41x
500        0.2716          73.4720            270.49x
1000       0.6748          178.9240           265.14x
2000       0.9318          773.8210           830.43x
------------------------------------------------------
"""
def benchmark_multiplication(num_digits):
    # Generate large random integers
    a = int(''.join(
        str(np.random.randint(1, 10)) for _ in range(num_digits)
    ))
    b = int(''.join(
        str(np.random.randint(1, 10)) for _ in range(num_digits)
    ))
    
    # Time school multiplication
    start = time.perf_counter()
    school_result = school_multiply(a, b)
    school_time = time.perf_counter() - start

    # Time FFT multiplication
    start = time.perf_counter()
    fft_result = fft_multiply(a, b)
    fft_time = time.perf_counter() - start
        
    return school_time, fft_time

for digits in [100, 500, 1000, 2000]:
    normal_t, fft_t = benchmark_multiplication(digits)
    speedup = normal_t / fft_t if fft_t > 0 else float('inf')
```

PS: I stumbled upon this by watching this [3Blue1Brown video](https://www.youtube.com/watch?v=KuXjwB4LzSA).