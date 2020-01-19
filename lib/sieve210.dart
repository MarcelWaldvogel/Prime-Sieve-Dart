import 'dart:typed_data';
import 'dart:math';

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

	//a 210 entry array that will be initialized with the index in the wheel
  // (offsets) for each modulus 210 not a multiple of 2, 3, 5, or 7
	static List<int> _lut_offsets;

	//a function that calculates the index of a number in the is_composite array.
	//It will be the xth number relatively prime to 210
  static int wheelSpokes(int n) {
    return n ~/ 210 * 48 + _lut_offsets[n % 210];
  }

  Uint64List primes;
  Uint8List composite;
  int length;

  _init_lut_offsets() {
    // The last two elements are not used; makes the code simpler, however.
    var l = List<int>(212);
    var key = 1;
    var value = 0;
    l[key] = value;
    for (var o in _offsets) {
      key += o;
      value++;
      l[key] = value;
    }
    // Allow some parallelism
    _lut_offsets = l;
  }
  
	//sievePrimes returns a pointer to an array of all the primes up to and including max.
	//the 0 element of this array is the length of the array.
  Sieve210(int max) {
    if (_lut_offsets == null) _init_lut_offsets();
    //create a list of chars representing whether or not every number to be sieved is composite.  Initialized to 0.
    composite = Uint8List((max ~/ 210 * 48 + 48) ~/ 8);

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
      if (composite[i1 ~/ 8] & (1 << (i1 & 7)) != 0) {
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

        if (composite[i2 ~/ 8] & (1 << (i2 & 7)) != 0) {
          continue;
        }

        multiple = p1 * p2;
        do {
          //cross off all multiple = p1*p2^n < max
          var wsm = wheelSpokes(multiple);
          composite[wsm ~/ 8] |= 1 << (wsm & 7);
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
