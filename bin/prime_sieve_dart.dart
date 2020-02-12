import 'dart:io';
import 'package:args/args.dart';
import 'package:prime_sieve_dart/prime_sieve_dart.dart';

bool positiveInt(String s) {
  var value = int.tryParse(s);
  return value != null && value >= 0;
}

void main(List<String> args) {
  var parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false)
    ..addFlag('query',
        abbr: 'q', help: "Whether to enter a primality query loop")
    ..addFlag('count',
        abbr: 'c', defaultsTo: true, help: "Whether to show the count")
    ..addFlag('print',
        abbr: 'p', defaultsTo: true, help: "Whether to print the primes");
  var results = parser.parse(args);
  if (results.rest.length != 1 || !positiveInt(results.rest[0])) {
    print("""Usage: prime_sieve.dart [options] <max>
    Calculates all primes up to <max> and then performs the action(s)
    specified by the options.

""" +
        parser.usage);
    exit(1);
  }

  var primes = Sieve210(int.parse(results.rest[0]));
  if (results['count']) {
    print(primes.length);
  }
  if (results['print']) {
    for (var i = 0; i < primes.length; i++) {
      print(primes.primes[i]);
    }
  }
  if (results['query']) {
    var line;
    print("Now enter your candidate primes one per line:");
    while ((line = stdin.readLineSync()) != null) {
      if (positiveInt(line)) {
        var n = int.parse(line);
        if (primes.isPrime(n)) {
          print("prime");
        } else {
          print("not prime");
        }
      } else {
        print("invalid query");
      }
    }
  }
}
