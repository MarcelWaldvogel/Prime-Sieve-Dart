import 'dart:typed_data';
import 'dart:math';

class _Flags {
  /// Number of flag bits to store.
  final int max;
  /// Actual memory provider.
  ///
  /// Uint8List is abstract, so we cannot easily subclass it.
  Uint8List mem;

  /// Create a flag array of [max] bits.
  _Flags(this.max) {
    mem = Uint8List((max + 7) ~/ 8);
  }

  operator [](int idx) {
    return mem[idx ~/ 8] & (1 << (idx & 7)) != 0;
  }

  operator []=(int idx, bool value) {
    if (value) {
      mem[idx ~/ 8] |= (1 << (idx & 7));
    } else {
      mem[idx ~/ 8] &= ~(1 << (idx & 7));
    }
  }
}

//the spaces between the wheel spokes.  The sieve skips all multiples of 2, 3, 5, and 7
//and that can be done by starting at 1 and adding these numbers in sequence.
class Sieve210 {
	static final _offsets = [
		10, 2, 4, 2, 4, 6,  2, 6,
		4, 2, 4, 6, 6, 2,  6, 4,
		2, 6, 4, 6, 8, 4,  2, 4,
		2, 4, 8, 6, 4, 6,  2, 4,
		6, 2, 6, 6, 4, 2,  4, 6,
		2, 6, 4, 2, 4, 2, 10, 2
	];

	//a 210 char array that has the index in the wheel (offsets) for each modulus 210 not a multiple of 2, 3, 5, or 7
	static final _lut_offsets = {
		1: 0, 11: 1, 13: 2, 17: 3, 19: 4, 23: 5, 29: 6, 31: 7,
		37: 8, 41: 9, 43: 10, 47: 11, 53: 12, 59: 13, 61: 14, 67: 15,
		71: 16, 73: 17, 79: 18, 83: 19, 89: 20, 97: 21,101: 22, 103: 23,
		107: 24, 109: 25, 113: 26, 121: 27, 127: 28, 131: 29, 137: 30, 139: 31,
		143: 32, 149: 33, 151: 34, 157: 35, 163: 36, 167: 37, 169: 38, 173: 39,
		179: 40, 181: 41, 187: 42, 191: 43, 193: 44, 197: 45, 199: 46, 209: 47
	};

	//a function that calculates the index of a number in the is_composite array.
	//It will be the xth number relatively prime to 210
  static int wheelSpokes(int n) {
    return n ~/ 210 * 48 + _lut_offsets[n % 210];
  }

  Uint64List primes;
  int length;

	//sievePrimes returns a pointer to an array of all the primes up to and including max.
	//the 0 element of this array is the length of the array.
  Sieve210(int max) {
    //create a list of chars representing whether or not every number to be sieved is composite.  Initialized to 0.
    var is_composite = _Flags(max ~/ 210 * 48 + 48);

    //primes_s is the estimated number of primes up to max, plus 1 (for the length of the primes array stored at 0)
    //TODO: calculate this better by using logarithmic integrals or by only pushing and sieving up to sqrt(max), then pushing.
    var primes_s = (max / log(max+1) * 1.2 + 10).ceil();
    primes = Uint64List(primes_s);

    //initializes the primes which are part of the wheel.
    primes[0] = 2;
    primes[1] = 3;
    primes[2] = 5;
    primes[3] = 7;

    //declare variables.
    int i = 4, p1, p2, i1 = 1, i2, step1 = 0, step2, multiple;

    //for every number still marked prime, cross off its multiples with every other number still marked prime and add it to the primes list.
    for (p1 = 11; p1 <= max; ++i1, p1 += _offsets[step1]) {
      //switch to the next step in offsets, wrapping around if it overflows.
      ++step1;
      if (step1 == 48) {
        step1 = 0;
      }

      //skip composite numbers.  Note that is_composite[i1] is just looking up if i1 has been marked composite, not doing a mathematical test.
      if (is_composite[i1]) {
        continue;
      }

      //add p1 to the list of primes
      primes[i++] = p1;
      if (i == primes_s) {
        //re allocate the primes array.  TODO: do this at most once, either using li instead of log or by stopping at the sqrt and allocating what's left minus the number of numbers crossed off.
        primes_s = (primes_s * 1.1).ceil();
        var t = Uint64List(primes_s);
        for (var c = 0; c < i; c++) {
          t[c] = primes[c];
        }
        primes = t;
      }

      //mark all multiples of p1 and some number still marked as prime as composite.
      //note: if a number is being marked composite, it times p1 still needs to be crossed of, e.g. p1 = 11, p2 = 11, cross off 121 and 1331 and so on.
      i2 = i1;
      step2 = step1 - 1;
      for (p2 = p1; p2 <= max ~/ p1; ++i2, p2 += _offsets[step2]) {
        ++step2;
        if (step2 == 48) {
          step2 = 0;
        }

        if (is_composite[i2]) {
          continue;
        }

        multiple = p1 * p2;
        do {
          //cross off all multiple = p1*p2^n < max
          is_composite[wheelSpokes(multiple)] = true;
        } while ((multiple *= p1) <= max);
      }
    }

    length = i;
  }

	//test if a number is prime by checking if it is in a list of primes.
	//binary search primes for n
	//TODO: use a jumping search
  bool isPrime(int n) {
    //start with max as the number of primes in primes.
    var max = primes.length;
    //start with min as 0 and mid as the average of min and max.
    var min = 0, mid = max ~/ 2;
    //binary search
    while (n != primes[mid]) {
      //eliminate the left side.
      if (n > primes[mid]) {
        min = mid + 1;
      } else {
        //eliminate the right side
        max = mid;
      }
      mid = max ~/ 2 + min ~/ 2;
      if (max == min) {
        //everything has been searched
        return false;
      }
    }
    return true;
  }
}
