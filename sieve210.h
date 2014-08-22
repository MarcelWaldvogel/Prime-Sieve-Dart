//sieve210.h

#pragma once

//returns an array of primes up to and including max.
//The 0 element is the number of primes (length of the rest of the array).
//can return null on allocation failure
uint64_t* sievePrimes(uint64_t max);

//checks if a number is prime by binary searching an array of primes for it.
char isPrime(uint64_t n, const uint64_t* primes);

