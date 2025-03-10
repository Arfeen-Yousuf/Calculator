import 'dart:async';
import 'dart:isolate';
import 'dart:math' as math;
import 'package:decimal/decimal.dart';

import 'dart:developer';

import 'trees.dart' show SingleVariableFunction, MultiVariableFunction;

extension FunctionTreeStringMethods on String {
  /// Generates a callable multi-variable function-tree.
  ///
  /// Example:
  ///
  ///     final sum = "a + b".toMultiVariableFunction(["a", "b"]);
  ///     print(sum({"a": 1, "b": 2})); // 3
  ///
  MultiVariableFunction toMultiVariableFunction(List<String> variableNames) =>
      MultiVariableFunction(
        fromExpression: this,
        withVariables: variableNames,
      );

  /// Generates a callable single variable function-tree.
  ///
  /// Example:
  ///
  ///     final f = "2 * e^x".toSingleVariableFunction();
  ///     print(f(2)); // 14.778112197861299
  SingleVariableFunction toSingleVariableFunction(
          [String variableName = 'x']) =>
      SingleVariableFunction(
        fromExpression: this,
        withVariable: variableName,
      );

  /// Evaluates the string as a mathematical expression.
  ///
  /// Example:
  ///
  ///     print("2 * pi".interpret()); // 6.283185307179586
  FutureOr<Decimal> interpret() async {
    final futureDecimal = toSingleVariableFunction()(Decimal.zero);
    return await futureDecimal;
  }
}

const _maxPrecision = 100;
final e = numberToDecimal(math.e);
final pi = numberToDecimal(math.pi);
final piThreshold = Decimal.parse('0.000000000000001');
final zero = Decimal.zero;
final one = Decimal.one;
final _point5 = Decimal.parse('0.5');

const _maxFactorial = 140;

///For caching factorials of numbers with decimal parts.
/// Uses custom hash code.
final _decimalFactorialMap = <int, Decimal?>{};
//For caching factorials of integers.
final _integerFactorialMap = <int, BigInt>{
  0: BigInt.zero,
  1: BigInt.one,
};

double degreesToRadians(double degrees) {
  return (degrees * math.pi) / 180;
}

double radiansToDegrees(double radians) {
  return (radians * 180) / math.pi;
}

double log10Double(double d) {
  return math.log(d) / math.log(10);
}

Decimal numberToDecimal(num n) => Decimal.parse('$n');

extension DecimalExtensions on Decimal {
  Decimal divide(Decimal divisor) {
    if (divisor.sign == 0) throw ArgumentError("Can't divide by 0");
    if (divisor == one) return this;
    return (this / divisor).toDecimal(
      scaleOnInfinitePrecision: _maxPrecision,
    );
  }

  Decimal power(Decimal exponent) {
    final result = math.pow(
      toDouble(),
      exponent.toDouble(),
    );
    return numberToDecimal(result);
  }

  Decimal powerNumber(num exponent) {
    final result = math.pow(
      toDouble(),
      exponent,
    );
    return numberToDecimal(result);
  }

  Decimal sin({required bool radianMode}) {
    double angle = toDouble();
    if (!radianMode) angle = degreesToRadians(angle);
    final result = numberToDecimal(math.sin(angle));
    return (result.abs() < piThreshold) ? zero : result;
  }

  Decimal asin({required bool radianMode}) {
    if (abs() > one) {
      throw StateError('sin⁻¹ is defined for [-1,1]');
    }
    double angle = math.asin(toDouble());
    if (!radianMode) angle = radiansToDegrees(angle);
    return numberToDecimal(angle);
  }

  Decimal cos({required bool radianMode}) {
    double angle = toDouble();
    if (!radianMode) angle = degreesToRadians(angle);
    final result = numberToDecimal(math.cos(angle));
    return (result.abs() < piThreshold) ? zero : result;
  }

  Decimal acos({required bool radianMode}) {
    if (abs() > one) {
      throw StateError('cos⁻¹ is defined for [-1,1]');
    }
    double angle = math.acos(toDouble());
    if (!radianMode) angle = radiansToDegrees(angle);
    return numberToDecimal(angle);
  }

  Decimal tan({required bool radianMode}) {
    double angle = toDouble();
    if (!radianMode) angle = degreesToRadians(angle);
    return numberToDecimal(math.tan(angle));
  }

  Decimal atan({required bool radianMode}) {
    double angle = math.atan(toDouble());
    if (!radianMode) angle = radiansToDegrees(angle);
    return numberToDecimal(angle);
  }

  Decimal sinh() {
    return (e.power(this) - e.power(-this)) * _point5;
  }

  Decimal cosh() {
    return (e.power(this) + e.power(-this)) * _point5;
  }

  Decimal tanh() {
    final d1 = (e.power(this) - e.power(-this));
    final d2 = (e.power(this) + e.power(-this));
    return d1.divide(d2);
  }

  /// Hyperbolic Inverse Sine (asinh)
  Decimal asinh() {
    return (this + (this * this + one).sqrt()).ln();
  }

  /// Hyperbolic Inverse Cosine (acosh) - Defined for x >= 1
  Decimal acosh() {
    if (this < one) {
      throw StateError('cosh⁻¹ is defined for [1, ∞)');
    }
    return (this + (this * this - one).sqrt()).ln();
  }

  /// Hyperbolic Inverse Tangent (atanh) - Defined for -1 < x < 1
  Decimal atanh() {
    if (this <= -one || this >= one) {
      throw StateError('tanh⁻¹ is defined for (-1, 1)');
    }

    Decimal d = (one + this).divide(one - this);
    return _point5 * d.ln();
  }

  /// Square Root
  Decimal sqrt() {
    if (sign == -1) throw StateError('\u221A is defined for positive numbers');
    return power(_point5);
  }

  /// Cube Root
  Decimal cuberoot() {
    return switch (sign) {
      0 => zero,
      1 => powerNumber(1 / 3),
      -1 => -((-this).powerNumber(1 / 3)),
      _ => zero,
    };
  }

  ///Returns natural logarithm of the decimal
  Decimal ln() {
    if (sign != 1) throw StateError('ln is defined for positive numbers');
    return numberToDecimal(math.log(toDouble()));
  }

  ///Returns base 10 logarithm of the decimal
  Decimal log10() {
    if (sign != 1) throw StateError('log is defined for positive numbers');
    double d = log10Double(toDouble());
    return numberToDecimal(d);
  }

  Future<Decimal> factorial() async {
    if (sign == -1) {
      throw StateError('Factorial is defined for non negative numbers');
    }

    if (isInteger) {
      int value = int.parse(toString());
      if (this > Decimal.fromInt(_maxFactorial)) {
        throw StateError(
          'Result outside of accepted range',
        );
      }
      if (_integerFactorialMap.containsKey(value)) {
        return Decimal.fromBigInt(_integerFactorialMap[value]!);
      }

      BigInt result = await _optimizedFactorial(value);
      _integerFactorialMap[value] = result;
      return Decimal.fromBigInt(result);
    } else {
      final hash = customHash();

      if (_decimalFactorialMap.containsKey(hash)) {
        if (_decimalFactorialMap[hash] == null) {
          throw StateError(
            'Factorial domain error',
          );
        }
        return _decimalFactorialMap[hash]!;
      }
      try {
        final decimalResult = _gammaLanczos(this + Decimal.one);
        _decimalFactorialMap[hash] = decimalResult;
        return decimalResult;
      } on Exception {
        _decimalFactorialMap[hash] = null;
        throw StateError(
          'Factorial domain error',
        );
      }
    }
  }

  static FutureOr<BigInt> _optimizedFactorial(int n) {
    if (n < 80) {
      return _computeFactorialSync(n);
    } else if (n <= _maxFactorial) {
      return _computeFactorialWithTwoIsolates(n);
    } else {
      throw StateError(
        'Result outside of accepted range',
      );
    }
  }

  static Decimal _gammaLanczos(Decimal d) {
    // Lanczos approximation parameters
    const p = <double>[
      676.5203681218851,
      -1259.1392167224028,
      771.3234287776531,
      -176.6150291621406,
      12.507343278686905,
      -0.13857109526572012,
      9.984369578019572e-6,
      1.5056327351493116e-7
    ];
    const g = 7.0;
    final z = d.toDouble() - 1;

    double a = 0.9999999999998099;
    for (int i = 0; i < p.length; i++) {
      a += p[i] / (z + i + 1);
    }

    final t = z + g + 0.5;
    final sqrtTwoPi = math.sqrt(2.0 * math.pi);
    final firstPart = sqrtTwoPi * math.pow(t, z + 0.5) * math.exp(-t);
    final result = firstPart * a;

    return numberToDecimal(result);
  }

  static BigInt _computeFactorialSync(int n) {
    BigInt result = BigInt.one;
    for (int i = 1; i <= n; i++) {
      result *= BigInt.from(i);
      _integerFactorialMap[i] = result;
    }

    return result;
  }

  static BigInt _factorialRange(int start, int end) {
    BigInt result = BigInt.one;
    for (int i = start; i <= end; i++) {
      result *= BigInt.from(i);
    }
    return result;
  }

  static Future<BigInt> _computeFactorialWithTwoIsolates(int n) async {
    //Iterate over the map and find appropriate base to start with
    int base = 1;
    _integerFactorialMap.keys.forEach((i) {
      if (i < n && i > base) base = i;
    });

    final part2 = await _computeFactorialRangeWithTwoIsolates(base + 1, n);
    return _integerFactorialMap[base]! * part2;
  }

  static Future<BigInt> _computeFactorialRangeWithTwoIsolates(
    int start,
    int end,
  ) async {
    if (end < start) return BigInt.one;
    if (start == end) return BigInt.from(start);

    int mid = (start + end) ~/ 2;
    final part1 = Isolate.run(() => _factorialRange(start, mid));
    final part2 = Isolate.run(() => _factorialRange(mid + 1, end));

    final results = await Future.wait([part1, part2]);
    return results[0] * results[1];
  }

  static Future<BigInt> _computeFactorialWithThreeIsolates(int n) async {
    int ind1 = n ~/ 3;
    int ind2 = 2 * ind1;

    final part1 = Isolate.run(() => _factorialRange(2, ind1));
    final part2 = Isolate.run(() => _factorialRange(ind1 + 1, ind2));
    final part3 = Isolate.run(() => _factorialRange(ind2 + 1, n));

    final results = await Future.wait([part1, part2, part3]);
    return results[0] * results[1] * results[2];
  }

  int customHash() => toStringAsFixed(35).substring(0, 35).hashCode;
}
