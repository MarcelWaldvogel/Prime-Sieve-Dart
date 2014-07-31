//sieve210.c

#pragma once

//returns an array of primes up to and including max.
//The 0 element is the number of primes (length of the rest of the array).
//can return null on allocation failure
uint64_t* sievePrimes(uint64_t max);

//checks if a number is prime by binary searching an array of primes for it.
char is_prime(uint64_t n, uint64_t* primes);
