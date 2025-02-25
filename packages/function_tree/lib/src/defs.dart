import 'dart:async';
import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:function_tree/src/extensions.dart';

/// A mapping of string representations to two-parameter functions.
final Map<String, Decimal Function(Decimal, Decimal)> twoParameterFunctionMap =
    {
  //'log': (b, x) => x.log().divide(b.log()),
  //'nrt': (n, x) => x.power( 1 / n),
  'pow': (x, p) => x.power(p)
};

/// A mapping of string representations of functions to LaTeX.
final Map<String, String> twoParameterFunctionLatexRepresentation = {
  'log': r'\log_{C1}\left(C2\right)',
  'nrt': r'\sqrt[C1]{C2}',
  'pow': r'{C1}^{C2}'
};

/// A mapping of string representations to functions.
final Map<String, FutureOr<Decimal> Function(Decimal)> oneParameterFunctionMap =
    {
  'sin': (x) => x.sin(radianMode: true),
  'cos': (x) => x.cos(radianMode: true),
  'tan': (x) => x.tan(radianMode: true),
  'acos': (x) => x.acos(radianMode: true),
  'asin': (x) => x.asin(radianMode: true),
  'atan': (x) => x.atan(radianMode: true),
  'sinDeg': (x) => x.sin(radianMode: false),
  'cosDeg': (x) => x.cos(radianMode: false),
  'tanDeg': (x) => x.tan(radianMode: false),
  'asinDeg': (x) => x.asin(radianMode: false),
  'acosDeg': (x) => x.acos(radianMode: false),
  'atanDeg': (x) => x.atan(radianMode: false),
  'sinh': (x) => x.sinh(),
  'cosh': (x) => x.cosh(),
  'tanh': (x) => x.tanh(),
  'asinh': (x) => x.asinh(),
  'acosh': (x) => x.acosh(),
  'atanh': (x) => x.atanh(),
  'sqrt': (x) => x.sqrt(),
  'cuberoot': (x) => x.cuberoot(),
  'log10': (x) => x.log10(), // Logarithm base 10
  'ln': (x) => x.ln(), // Natural logarithm (base e)
  'abs': (x) => x.abs(),
  'round': (x) => x.round(),
  'fact': (x) => x.factorial(),
};

/// A mapping of string representations of functions to LaTeX.
final Map<String, String> oneParameterFunctionLatexRepresentation = {
  'abs': r'\left| C \right| ',
  'acos': r'\arccos\left( C \right) ',
  'asin': r'\arcsin\left( C \right) ',
  'atan': r'\arctan\left( C \right) ',
  'ceil': r'\lceil C \rceil ',
  'cos': r'\cos\left( C \right) ',
  'cosh': r'\cosh\left( C \right) ',
  'cot': r'\cot\left( C \right) ',
  'coth': r'\coth\left( C \right) ',
  'csc': r'\csc\left( C \right) ',
  'csch': r'\csch\left( C \right) ',
  'exp': r'\exp\left( C \right) ',
  'floor': r'\lfloor C \rfloor ',
  'ln': r'\ln\left( C \right) ',
  'log': r'\log\left( C \right) ',
  'round': r'\left[ C \right] ',
  'sec': r'\sec\left( C \right) ',
  'sech': r'\sech\left( C \right) ',
  'sin': r'\sin\left( C \right) ',
  'sinh': r'\sinh\left( C \right) ',
  'sqrt': r'\sqrt{ C } ',
  'tan': r'\tan\left( C \right) ',
  'tanh': r'\tanh\left( C \right) '
};

final piDecimal = numberToDecimal(math.pi);
final ln2Decimal = numberToDecimal(math.ln2);
final ln10Decimal = numberToDecimal(math.ln10);
final log2eDecimal = numberToDecimal(math.log2e);
final log10eDecimal = numberToDecimal(math.log10e);
final sqrt1_2Decimal = numberToDecimal(math.sqrt1_2);
final sqrt2Decimal = numberToDecimal(math.sqrt2);

/// A mapping of string representations to constants.
final Map<String, Decimal> constantMap = {
  'E': e,
  'PI': piDecimal,
  'LN2': ln2Decimal,
  'LN10': ln10Decimal,
  'LOG2E': log2eDecimal,
  'LOG10E': log10eDecimal,
  'SQRT1_2': sqrt1_2Decimal,
  'SQRT2': sqrt2Decimal,
  'e': e,
  'pi': piDecimal,
  'tau': piDecimal * Decimal.fromInt(2),
  'phi': numberToDecimal(1.61803398875),
  'ln2': ln2Decimal,
  'ln10': ln10Decimal,
  'log2e': log2eDecimal,
  'log10e': log10eDecimal,
  'sqrt1_2': sqrt1_2Decimal,
  'sqrt2': sqrt2Decimal,
};

/// A mapping of string representations of constants to LaTeX.
final Map<String, String> constantLatexRepresentation = {
  'E': 'e ',
  'LN2': r'\ln 2 ',
  'LN10': r'\ln 10 ',
  'LOG2E': r'\log_2e ',
  'LOG10E': r'\log_{10} e ',
  'PI': r'\pi ',
  'SQRT1_2': r'\frac{\sqrt2}{2} ',
  'SQRT2': r'\sqrt{2} ',
  'e': 'e ',
  'ln2': r'\ln 2 ',
  'ln10': r'\ln 10 ',
  'log2e': r'\log_2e ',
  'log10e': r'\log_{10} e ',
  'pi': r'\pi ',
  'sqrt1_2': r'\frac{\sqrt2}{2} ',
  'sqrt2': r'\sqrt{2} '
};
