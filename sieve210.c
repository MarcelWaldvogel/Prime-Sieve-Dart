#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>


const char offsets[] = {
	10, 2, 4, 2, 4, 6,  2, 6,
	 4, 2, 4, 6, 6, 2,  6, 4,
	 2, 6, 4, 6, 8, 4,  2, 4,
	 2, 4, 8, 6, 4, 6,  2, 4,
	 6, 2, 6, 6, 4, 2,  4, 6,
	 2, 6, 4, 2, 4, 2, 10, 2
};


const char lut_offsets[] = {
	[  1] =  0, [ 11] =  1, [ 13] =  2, [ 17] =  3, [ 19] =  4, [ 23] =  5, [ 29] =  6, [ 31] =  7,
	[ 37] =  8, [ 41] =  9, [ 43] = 10, [ 47] = 11, [ 53] = 12, [ 59] = 13, [ 61] = 14, [ 67] = 15,
	[ 71] = 16, [ 73] = 17, [ 79] = 18, [ 83] = 19, [ 89] = 20, [ 97] = 21, [101] = 22, [103] = 23,
	[107] = 24, [109] = 25, [113] = 26, [121] = 27, [127] = 28, [131] = 29, [137] = 30, [139] = 31,
	[143] = 32, [149] = 33, [151] = 34, [157] = 35, [163] = 36, [167] = 37, [169] = 38, [173] = 39,
	[179] = 40, [181] = 41, [187] = 42, [191] = 43, [193] = 44, [197] = 45, [199] = 46, [209] = 47
};


uint64_t wheel_spokes(uint64_t n){
	return n/210*48 + lut_offsets[n%210];
}


uint64_t* sievePrimes(uint64_t max){
    char* is_composite = calloc(max/210*48 + 48, sizeof(char));
    if(!is_composite){
		return 0;
	}
	
    uint64_t primes_s = max/log(max) + 1;
    uint64_t* primes = malloc(primes_s*sizeof(uint64_t));
    if(!primes){
		return 0;
	}
	
	primes[1] = 2;
	primes[2] = 3;
	primes[3] = 5;
	primes[4] = 7;
	
    uint64_t i = 1, p1, p2, i1, i2, step1, step2, multiple;
    uint64_t* t;
    
    for(i1 = 1, p1 = 11, step1 = 0; p1 <= max; ++i1, p1 += offsets[step1]){
		++step1;
		if(step1 == 48){
			step1 = 0;
		}
		
        if(is_composite[i1]){
			continue;
		}
		
        //printf("%lu\n",p1);
        primes[i++] = p1;
        if(i == primes_s){
			primes_s *= 1.1;
			t = realloc(primes, primes_s*sizeof(uint64_t));
			if(!t){
				free(is_composite);
				return primes;
			}
			primes=t;
		}
		
        for(i2 = i1, p2 = p1, step2 = step1; p2 <= max/p1; ++i2, p2 += offsets[step2]){
			++step2;
			if(step2 == 48){
				step2 = 0;
			}
			
            if(is_composite[i2]){
				continue;
			}
			
            multiple = p1*p2;
            do{
                is_composite[wheel_spokes(multiple)] = 1;
            }while((multiple *= p1) <= max);
        }
    }
    
    free(is_composite);
    primes[0] = i;
    t = realloc(primes, i*sizeof(uint64_t));
    if(t){
		primes = t;
	}
    return primes;
}


//binary search primes for n
char is_prime(uint64_t n, uint64_t* primes){
	uint64_t max = primes[0];
	primes += 1;
	uint64_t min = 0, mid = max/2;
	while(n != primes[mid]){
		if(n > primes[mid]){
			min = mid + 1;
		}else{
			max = mid;
		}
		mid = max/2 + min/2;
		if(max == min){
			return 0;
		}
	}
	return 1;
}


int main(){
	uint64_t* P=sievePrimes(1000000000);
	free(P);
	return 0;
}

