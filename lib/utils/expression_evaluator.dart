import 'dart:developer' as dev;
import 'dart:math';

import 'package:function_tree/function_tree.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class ExpressionEvaluator {
  //final numberRegExp = RegExp(r'\d+(\.\d+)?');
  //Allow upto 10 decimal points
  final numberFormatter = NumberFormat('#,##0.##########');

  num calculateResult(
    String? expr, {
    bool angleInDegree = false,
    int precision = 10,
  }) {
    dev.log('Expression Evaluating $expr');
    if (expr == null || expr.isEmpty) return double.nan;

    //Replace the function names and constants
    expr = expr
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

    if (angleInDegree) expr = _degreeAngleExpression(expr);

    expr = _balanceBrackets(expr);
    if (expr == null) return double.nan;

    if (expr.startsWith('-')) expr = '0$expr';
    expr = expr.replaceAll('(-', '(0-');
    expr = _removePercentages(expr);

    try {
      dev.log('Expression Interpreting $expr');
      final result = expr.interpret();
      if (result > pow(10, 13)) {
        dev.log('Large Result $result');
        return (result.toDouble() * 1000).truncate() / 1000;
      }

      return result;
    } on ArgumentError {
      return double.nan;
    } on Exception {
      return double.nan;
    }
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
      return '${expr.substring(0, appliedExprInd)}($appliedExprResult*(1-${percentExprResult / 100}))${expr.substring(index + 1)}';
    }

    if (expr[percentExprInd - 1] == '+') {
      return '${expr.substring(0, appliedExprInd)}($appliedExprResult*(1+${percentExprResult / 100}))${expr.substring(index + 1)}';
    }

    return expr;
  }

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
}
