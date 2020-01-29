# Prime-Sieve-Dart

A prime number generator written in Dart, using Euler's sieve and a wheel size
of 210.

The code is based as closely as possible on
[hacatu](https://github.com/hacatu)'s
[Prime-Sieve](https://github.com/hacatu/Prime-Sieve).

## Performance

The performance of the prime determination is about half as fast as the C
implementation. On my machine, it requires about 7.5&#8239;s (Dart) instead of 3.5&#8239;s
(C) to find all primes up to 10⁹.

(Printing, however, is way slower, instead of 3.5&#8239;s for the C version, the
output takes about 80&#8239;s.)

## Usage
`dart example/prime_sieve.dart [options] <max>`

Determine primality for all numbers up to `max`. `max` should not exceed
about 2⁶⁰ (or 2⁵⁰, when translating to JavaScript) or the size of your
memory, whatever is smaller.

## Options
* `--help`: Print help
* `--[no-]count`: Whether to output the count of primes found.
  (Default: true.)
* `--[no-]print`: Whether to output the primes after calculating them.
  (Default: true.)
* `--query`: Whether to enter a query input loop for primality tests after
  possibly printing the values.
