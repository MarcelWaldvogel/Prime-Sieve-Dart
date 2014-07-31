/* ptest.c
 * test the Prime Sieve
*/
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "sieve210.h"


int main(int argc, char** argv){
	uint64_t max = 1000000;
	char print;
	if(argc > 1){
		max = atoll(argv[1]);
	}
	uint64_t* P = sievePrimes(max);
	if(argc > 2){
		print = atoi(argv[2]);
		if(print){
		    uint64_t max = P[0], i;
			for(i = 1; i <= max; ++i){
				printf("%lu\n",P[i]);
			}
		}
	}else{
		char* line = 0;
		size_t len = 0;
		while(1 < getline(&line, &len, stdin)){
			if(isPrime(atoll(line),P)){
				printf("prime\n");
			}else{
				printf("not prime\n");
			}
		}
		free(line);
	}
	free(P);
}

	
