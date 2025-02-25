import 'package:calculator/extensions/string.dart';
import 'package:decimal/decimal.dart';
import 'package:function_tree/function_tree.dart';
import 'package:intl/intl.dart';

import 'constants.dart';
import 'utils.dart';

class ExpressionEvaluator {
  //Allow upto 10 decimal points
  final numberFormatter = NumberFormat('#,##0.##########');

  ///May throw ArgumentError or StateError
  Future<Decimal> calculateResult(
    String? expr, {
    required bool angleInDegree,
  }) async {
    if (expr == null || expr.isEmpty) {
      throw ArgumentError('Expression must be non empty');
    }
    final originalExpression = expr;

    //Percentage and factorial can not occur consecutively: !% or %!
    if (expr.contains('!${CalculatorConstants.percentage}') ||
        expr.contains('${CalculatorConstants.percentage}!')) {
      throw ArgumentError(AppStrings.invalidFormat);
    }

    expr = expr.replaceAll(',', '');
    expr = _removeImplicitMultiplications(expr);
    expr = _removeFactorials(expr);
    //Replace the function names and constants
    expr = _cleanExpression(expr);
    if (angleInDegree) expr = _degreeAngleExpression(expr);

    expr = _balanceBrackets(expr);
    if (expr == null) {
      throw ArgumentError('Brackets not balanced');
    }

    if (expr.startsWith('-')) expr = '0$expr';
    // (-4.3432.9032% etc
    expr = expr.replaceAllMapped(RegExp(r'\(-[0-9\.]+%'), (match) {
      final matchedStr = match.group(0)!;
      final numberPart = matchedStr.substring(
        2,
        matchedStr.length - 1,
      );

      return '(-($numberPart/100)';
    });
    expr = expr.replaceAll('(-', '(0-');
    expr = await _removePercentages(expr);

    try {
      Decimal result = await expr.interpret();
      if (containsTrigometricFunction(originalExpression)) {
        result = result.round(scale: 15);
      }
      return result;
    } on Exception {
      throw const FormatException(AppStrings.invalidFormat);
    }
  }

  String _cleanExpression(String expr) {
    return expr
        .replaceAll(CalculatorConstants.addition, '+')
        .replaceAll(CalculatorConstants.subtraction, '-')
        .replaceAll(CalculatorConstants.multiplication, '*')
        .replaceAll(CalculatorConstants.division, '/')
        .replaceAll(CalculatorConstants.power, '^')
        .replaceAll(ScientificConstants.pi, 'pi')
        .replaceAll(ScientificConstants.eular, 'e')
        .replaceAll(ScientificConstants.phi, 'phi')
        .replaceAll(ScientificFunctions.round, 'round')
        .replaceAll(ScientificFunctions.sine, 'sin')
        .replaceAll(ScientificFunctions.cosine, 'cos')
        .replaceAll(ScientificFunctions.tangent, 'tan')
        .replaceAll(ScientificFunctions.sineInverse, 'asin')
        .replaceAll(ScientificFunctions.cosineInverse, 'acos')
        .replaceAll(ScientificFunctions.tangentInverse, 'atan')
        .replaceAll(ScientificFunctions.sineHyperbolic, 'sinh')
        .replaceAll(ScientificFunctions.cosineHyperbolic, 'cosh')
        .replaceAll(ScientificFunctions.tangentHyperbolic, 'tanh')
        .replaceAll(ScientificFunctions.sineHyperbolicInverse, 'asinh')
        .replaceAll(ScientificFunctions.cosineHyperbolicInverse, 'acosh')
        .replaceAll(ScientificFunctions.tangentHyperbolicInverse, 'atanh')
        .replaceAll(ScientificFunctions.squareRoot, 'sqrt')
        .replaceAll(ScientificFunctions.cubeRoot, 'cuberoot')
        .replaceAll(ScientificFunctions.naturalLogarithm, 'ln')
        .replaceAll(ScientificFunctions.logarithm, 'log10')
        .replaceAll(ScientificFunctions.absolute, 'abs');
  }

  ///Remove implicit multiplications between constants and numbers
  String _removeImplicitMultiplications(String expr) {
    RegExp pattern = RegExp(
      r'([0-9\.]*[\u03C0\u0117\u03D5]+[0-9\.]*)+',
      unicode: true,
    );

    return expr.replaceAllMapped(pattern, (match) {
      final matchedStr = match.group(0)!;

      List<String> numbers = matchedStr.split(
        RegExp(
          r'[\u03C0\u0117\u03D5]',
          unicode: true,
        ),
      )..removeWhere((str) => str.isEmpty);
      List<String> constants =
          matchedStr.replaceAll(RegExp(r'[0-9\.]+'), '').split('');

      String joinedStr = (numbers + constants).join('*');

      return '($joinedStr)';
    });
  }

  String _degreeAngleExpression(String expr) {
    for (final func in [
      ...ScientificFunctions.trigonometric,
      ...ScientificFunctions.trigonometricInverses
    ]) {
      expr = expr.replaceAll('$func(', '${func}Deg(');
    }

    return expr;
  }

  String? _balanceBrackets(String expr) {
    int level = 0;
    for (int i = 0; i < expr.length; i++) {
      if (expr[i] == '(') {
        level++;
      } else if (expr[i] == ')') {
        level--;
        //Check if the brackets cause an invalid expression
        if (level < 0) return null;
      }
    }

    //Else add the remaining right brackets to the expression
    return expr + (')' * level);
  }

  Future<String> _removePercentages(String expr) async {
    int index = expr.indexOf(CalculatorConstants.percentage);
    while (index != -1) {
      expr = await _removePercentageAtIndex(expr, index);
      index = expr.indexOf(CalculatorConstants.percentage);
    }

    return expr;
  }

  Future<String> _removePercentageAtIndex(String expr, int index) async {
    //The index where percentage expressions starts
    int percentExprInd = index - 1;
    if (percentExprInd < 0) return '';

    if (expr[percentExprInd] == ')') {
      percentExprInd = _matchClosingBracket(expr, percentExprInd);
      final endsWithFunc = _endsWithFunction(expr.substring(0, percentExprInd));
      if (endsWithFunc != null) percentExprInd -= endsWithFunc.length;
    } else {
      while (percentExprInd >= 0) {
        final char = expr[percentExprInd];
        if (!(char == '.' || char.isDigit)) break;
        percentExprInd--;
      }

      percentExprInd++;
    }

    final Decimal percentExprResult =
        await expr.substring(percentExprInd, index).interpret();

    //Now find the expression on which percentage is to be applied
    bool replaceWithDivision = false;
    final afterExpression = expr.substring(index + 1);

    if (!(afterExpression.isEmpty ||
        afterExpression.startsWith('+') ||
        afterExpression.startsWith('-') ||
        afterExpression.startsWith(')'))) {
      replaceWithDivision = true;
    }

    if (!replaceWithDivision) {
      final beforeExpression = expr.substring(0, percentExprInd);
      if (!(beforeExpression.isNotEmpty &&
          (beforeExpression.endsWith('+') ||
              (beforeExpression.endsWith('-') &&
                  beforeExpression.length > 1)))) {
        replaceWithDivision = true;
      }
    }

    if (replaceWithDivision) {
      return '${expr.substring(0, percentExprInd)}(${expr.substring(percentExprInd, index)}/100)${expr.substring(index + 1)}';
    }

    int balancingBracket = 0;
    int appliedExprInd = percentExprInd - 1;
    while (appliedExprInd >= 0) {
      if (expr[appliedExprInd] == ')') {
        balancingBracket++;
      } else if (expr[appliedExprInd] == '(') {
        if (balancingBracket == 0) break;
        balancingBracket--;
      }

      appliedExprInd--;
    }
    appliedExprInd++;

    final Decimal appliedExprResult =
        await expr.substring(appliedExprInd, percentExprInd - 1).interpret();
    String char = expr[percentExprInd - 1];
    if (['-', '+'].contains(char)) {
      return '${expr.substring(0, appliedExprInd)}'
          '($appliedExprResult*(1$char${divideDecimals(percentExprResult, Decimal.fromInt(100))}))'
          '${expr.substring(index + 1)}';
    }

    return expr;
  }

  String _removeFactorials(String expr) {
    //Numbers
    expr = expr.replaceAllMapped(
      RegExp(r'([0-9\.]+)!'),
      (match) {
        String numStr = match.group(0)!;
        return 'fact(${numStr.substring(0, numStr.length - 1)})';
      },
    );

    //Constants
    for (final constant in ScientificConstants.constants) {
      expr = expr.replaceAll('$constant!', 'fact($constant)');
    }

    //Functions
    int factInd = expr.indexOf('!');
    while (factInd != -1) {
      expr = _removeFactorialAtIndex(expr, factInd);
      factInd = expr.indexOf('!');
    }

    return expr;
  }

  ///Removes the factrial at the given [index] in [expr].
  ///Asssumes that a closing bracket appears before ! at [index - 1]
  static String _removeFactorialAtIndex(String expr, int index) {
    final openBracketInd = _matchClosingBracket(
      expr,
      index - 1,
    );
    if (openBracketInd == -1) {
      throw ArgumentError(AppStrings.invalidFormat);
    }

    final exprBeforeOpenBracket = expr.substring(0, openBracketInd);

    //Check if there is a function before the opening bracket
    String? funcStr;
    if (openBracketInd > 0) {
      funcStr = _endsWithFunction(exprBeforeOpenBracket);
    }

    if (funcStr != null) {
      final exprBeforeFunc = expr.substring(
        0,
        openBracketInd - funcStr.length,
      );
      return '$exprBeforeFunc'
          'fact(${expr.substring(exprBeforeFunc.length, index)})'
          '${expr.substring(index + 1)}';
    } else {
      return '$exprBeforeOpenBracket'
          'fact${expr.substring(openBracketInd, index)}'
          '${expr.substring(index + 1)}';
    }
  }

  ///Returns the index of corresponding opening bracket if any.
  ///Else returns -1
  static int _matchClosingBracket(String expr, int closingBracketIndex) {
    int balanceBrackets = 1;
    int ind = closingBracketIndex - 1;

    while (ind >= 0 && balanceBrackets > 0) {
      if (expr[ind] == ')') {
        balanceBrackets++;
      } else if (expr[ind] == '(') {
        balanceBrackets--;
        if (balanceBrackets == 0) return ind;
      }

      ind--;
    }

    return -1;
  }

  static String? _endsWithFunction(String str) {
    if (str.isEmpty) return null;

    String longest = '';
    for (final func in ScientificFunctions.functionNames) {
      if (str.endsWith(func) && func.length > longest.length) {
        longest = func;
      }
    }

    for (final func in [
      ...ScientificFunctions.trigonometric,
      ...ScientificFunctions.trigonometricInverses,
    ]) {
      final degreeFunc = '${func}Deg';
      if (str.endsWith(degreeFunc) && degreeFunc.length > longest.length) {
        longest = degreeFunc;
      }
    }

    return longest.isEmpty ? null : longest;
  }

  static Decimal divideDecimals(Decimal d1, Decimal d2) {
    if (d2.sign == 0) throw ArgumentError("Can't divide by 0");
    if (d2 == Decimal.one) return d1;
    return (d1 / d2).toDecimal(scaleOnInfinitePrecision: 100);
  }
}
