/* ptest.c
 * test the Prime Sieve
*/
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "sieve210.h"


int main(int argc, char** argv){
	uint64_t max = 1000000;
	if(argc > 1){
		max = atoll(argv[1]);
	}else{
		puts("No maximum specified.  Assuming \"ptest 1000000\".");
	}
	uint64_t* P = sievePrimes(max);
	if(argc > 2){
		char print = atoi(argv[2]);
		if(print){
		    uint64_t max = P[0], i;
			for(i = 1; i <= max; ++i){
				printf("%lu\n",P[i]);
			}
		}
	}else{
		printf("Printing unspecified.  Use \"1\" to print and \"0\" to not print.\n\
Running in primality testing mode.  Enter a number up to %lu inclusive:\n", max);
		char* line = 0;
		size_t len = 0;
		while(1 < getline(&line, &len, stdin)){
			if(isPrime(atoll(line),P)){
				puts("prime");
			}else{
				puts("not prime");
			}
		}
		free(line);
	}
	free(P);
}

	
