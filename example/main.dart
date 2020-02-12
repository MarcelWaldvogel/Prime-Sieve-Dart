import 'package:prime_sieve_dart/prime_sieve_dart.dart';

void main() {
  var primes = Sieve210(10);

  print("There are ${primes.length} primes below 10.");
  print("They are:");
  for (int i = 0; i < primes.length; i++) {
    print("* ${primes.primes[i]}");
  }
  print("Is 3 prime? ${primes.isPrime(3)}");
  print("Is 4 prime? ${primes.isPrime(4)}");
}
