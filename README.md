Prime-Sieve
===========

A prime number generator written in C, using Euler's sieve and a wheel size of 210.

Usage: `./ptest [max [print-mode]]`

* Determine primality for all numbers up to `max`. `max` is bounded by 2^64-1.
* `print-mode` can take the following values:
  - `1`: Print all prime numbers.
  - `0`: Only calculate them (for speed tests).
  - absent: Primality test mode. Enter numbers for which you want to test primality.
