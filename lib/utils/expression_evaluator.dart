import 'dart:developer' as dev;
//import 'dart:math';

//import 'package:calculator/utils/utils.dart';
import 'package:calculator/extensions/string.dart';
import 'package:decimal/decimal.dart';
import 'package:function_tree/function_tree.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class ExpressionEvaluator {
  //final numberRegExp = RegExp(r'\d+(\.\d+)?');
  //Allow upto 10 decimal points
  final numberFormatter = NumberFormat('#,##0.##########');

  ///May throw ArgumentError or StateError
  Decimal calculateResult(
    String? expr, {
    required bool angleInDegree,
  }) {
    dev.log('Expression Evaluating $expr , Degrees: $angleInDegree');
    if (expr == null || expr.isEmpty) {
      throw ArgumentError('Expression must be non empty');
    }

    //Percentage and factorial can not occur consecutively: !% or %!
    if (expr.contains('!${CalculatorConstants.percentage}') ||
        expr.contains('${CalculatorConstants.percentage}!')) {
      throw ArgumentError(AppStrings.invalidFormat);
    }

    //Replace the function names and constants
    expr = _cleanExpression(expr);
    if (angleInDegree) expr = _degreeAngleExpression(expr);

    expr = _balanceBrackets(expr);
    if (expr == null) {
      throw ArgumentError('Brackets not balanced');
    }

    if (expr.startsWith('-')) expr = '0$expr';
    //TODO: Resolve issue for (-4% etc
    expr = expr.replaceAll('(-', '(0-');
    expr = _removePercentages(expr);
    expr = _removeFactorials(expr);

    dev.log('Expression Interpreting $expr');
    try {
      return expr.interpret();
    } on Exception {
      throw ArgumentError('Result outside of accepted range');
    }

    // final tenPower15 = pow(10, 15);
    // if (result > tenPower15) return double.infinity;
    // if (result < -tenPower15) return double.negativeInfinity;
    // if (result.abs() < pow(10, -8)) return 0;

    // if (result.abs() > pow(10, 13)) {
    //   dev.log('Large Result $result');
    //   return (result.toDouble() * 1000).truncate() / 1000;
    // }

    //return result;
  }

  String _cleanExpression(String expr) {
    return expr
        .replaceAll(',', '')
        .replaceAll(CalculatorConstants.space, '')
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
    //Check for bracket balancing
    int bracketBalance =
        '('.allMatches(expr).length - ')'.allMatches(expr).length;
    //If right brackets are greater than left brackets, then the expression
    //is surely invalid
    if (bracketBalance < 0) return null;

    //Else add the remaining right brackets to the expression
    return expr + (')' * bracketBalance);
  }

  String _removePercentages(String expr) {
    int index = expr.indexOf(CalculatorConstants.percentage);
    while (index != -1) {
      expr = _removePercentageAtIndex(expr, index);
      index = expr.indexOf(CalculatorConstants.percentage);
    }

    return expr;
  }

  String _removePercentageAtIndex(String expr, int index) {
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
        if (!(char == '.' || isDigit(char))) break;
        percentExprInd--;
      }

      percentExprInd++;
    }

    final percentExprResult = expr.substring(percentExprInd, index).interpret();

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

    final appliedExprResult =
        expr.substring(appliedExprInd, percentExprInd - 1).interpret();
    if (expr[percentExprInd - 1] == '-') {
      return '${expr.substring(0, appliedExprInd)}'
          '($appliedExprResult*(1-${divideDecimals(percentExprResult, Decimal.fromInt(100))}))'
          '${expr.substring(index + 1)}';
    }

    if (expr[percentExprInd - 1] == '+') {
      return '${expr.substring(0, appliedExprInd)}($appliedExprResult*(1+${divideDecimals(percentExprResult, Decimal.fromInt(100))}))${expr.substring(index + 1)}';
    }

    return expr;
  }

  String _removeFactorials(String expr) {
    expr = expr.replaceAllMapped(
      RegExp(r'([0-9\.]+)!'),
      (match) {
        String numStr = match.group(0)!;
        return 'fact(${numStr.substring(0, numStr.length - 1)})';
      },
    );

    int factInd = expr.indexOf('!');
    while (factInd != -1) {
      expr = _removeFactorialAtIndex(expr, factInd);
      factInd = expr.indexOf('!');
    }

    return expr;
  }

  ///Removes the factrial at the given [index] in [expr].
  ///Asssumes that a closing bracket appears before ! at [index - 1]
  String _removeFactorialAtIndex(String expr, int index) {
    int openBracketInd = _matchClosingBracket(
      expr,
      index - 1,
    );
    if (openBracketInd == -1) {
      throw ArgumentError('Expression must be non empty');
    }

    final exprBeforeOpenBracket = expr.substring(0, openBracketInd);

    //Check if there is a function before the opening bracket
    if (openBracketInd > 0 && exprBeforeOpenBracket[0].isAlphabet) {
      final funcStr = _endsWithFunction(exprBeforeOpenBracket);
      if (funcStr == null) {
        throw ArgumentError('Expression must be non empty');
      }

      final exprBeforeFunc = expr.substring(
        0,
        openBracketInd - funcStr.length,
      );
      return '$exprBeforeFunc'
          'fact(${expr.substring(exprBeforeFunc.length, index)})';
    } else {
      //...sin(lkhf)!
      //...fact(sin(lkhf))
      return '$exprBeforeOpenBracket'
          'fact${expr.substring(openBracketInd, index)}'
          '${expr.substring(index + 1)}';
    }
  }

  ///Returns the index of corresponding opening bracket if any.
  ///Else returns -1
  int _matchClosingBracket(String expr, int closingBracketIndex) {
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

  String? _endsWithFunction(String str) {
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

  bool isDigit(String str) => RegExp(r'^\d$').hasMatch(str);

  Decimal divideDecimals(Decimal d1, Decimal d2) {
    if (d2.sign == 0) throw ArgumentError("Can't divide by 0");
    if (d2 == Decimal.one) return d1;
    return (d1 / d2).toDecimal(scaleOnInfinitePrecision: 100);
  }
}
