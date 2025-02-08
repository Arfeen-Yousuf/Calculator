// ignore_for_file: unused_local_variable, avoid_print

import 'package:decimal/decimal.dart';
import 'package:function_tree/function_tree.dart';
import 'package:function_tree/src/extensions.dart';

import 'dart:math' as math;

double stirlingFactorialApprox(int n) =>
    math.sqrt(2 * math.pi * n) * math.pow(n / math.e, n);

void main() async {
  // String exp1 = '1/3';
  // String exp2 =
  //     '((e ^ sin(pi / 3) + 159672.439856 ^ 2.5) ^ (45 ^ 0.25) * atanh(0.9)) * cuberoot(2)';
  String exp3 = '5.4.274!';

  Decimal result = await exp3.interpret();
  print(result);

  // result = exp3.interpret();

  //print(stirlingFactorialApprox(306));

  // Decimal d = Decimal.parse('4.2');
  // print(d);
  // print(d.factorial());

  // print(result.toString().length);

  // result = result.truncate();
  // print('$result');
  // print(result.toString().length);
}
