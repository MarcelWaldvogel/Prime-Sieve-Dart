/* ptest.c
 * test the Prime Sieve
*/
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "sieve210.h"


int main(int argc, char** argv){
	uint64_t max=1000000;
	char print=1;
	if(argc>1){
		max=atoll(argv[1]);
	}
	if(argc>2){
		print=atoi(argv[2]);
	}
	uint64_t* P=sievePrimes(max);
	if(print){
	    uint64_t max = P[0], i;
		for(i = 1; i < max; ++i){
			printf("%lu\n",P[i]);
		}
	}
}
