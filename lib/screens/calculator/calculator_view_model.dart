import 'dart:developer' as dev;
import 'dart:math';

import 'package:calculator/enums/history_log_action.dart';
import 'package:calculator/screens/history/history_screen.dart';
import 'package:calculator/screens/history/history_view_model.dart';
import 'package:calculator/services/history_database.dart';
import 'package:calculator/utils/constants.dart';
import 'package:calculator/utils/expression_evaluator.dart';
import 'package:calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'formatters/thousands_formatter.dart';

class CalculatorViewModel extends ChangeNotifier {
  final textEditingController = TextEditingController();
  final focusNode = FocusNode();
  final _evaluator = ExpressionEvaluator();

  bool _isScientific = false;
  get isScientific => _isScientific;
  void toogleScientific() {
    _isScientific = !_isScientific;
    _result = _evaluator.calculateResult(
      textEditingController.text,
      angleInDegree: _angleInDegree,
    );
    notifyListeners();
  }

  bool _showScientificInverse = false;
  get showScientificInverse => _showScientificInverse;
  void toogleShowScientificInverse() {
    _showScientificInverse = !_showScientificInverse;
    notifyListeners();
  }

  bool _angleInDegree = true;
  bool get angleInDegree => _angleInDegree;
  void toogleAngleInDegree() {
    _angleInDegree = !_angleInDegree;
    _result = _evaluator.calculateResult(
      textEditingController.text,
      angleInDegree: _angleInDegree,
    );
    notifyListeners();
  }

  bool _hasTrigonometricFunction = false;
  bool get hasTrigonometricFunction => _hasTrigonometricFunction;

  num _result = double.nan;
  num get result => _result;

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  static bool isDigit(String str) => RegExp(r'^\d$').hasMatch(str);

  void clear() {
    textEditingController.clear();
    _result = double.nan;
    notifyListeners();
  }

  // Binary operators
  void addDivision() => _addBinaryOperator(CalculatorConstants.division);
  void addMultiplication() =>
      _addBinaryOperator(CalculatorConstants.multiplication);
  void addSubtraction() => _addBinaryOperator(CalculatorConstants.subtraction);
  void addAddition() => _addBinaryOperator(CalculatorConstants.addition);
  void addPower() => _addBinaryOperator(CalculatorConstants.power);

  void computeResult(BuildContext context) {
    if (isSimpleNumber(textEditingController.text)) {
      return;
    }

    if (_result.toString().contains(nanString)) {
      showToast('Invalid Format.');
      return;
    }

    if (_result == double.infinity) {
      showToast('Result too large to show.');
      return;
    }
    if (_result == double.negativeInfinity) {
      showToast('Result too small to show.');
      return;
    }

    final newHistoryLog = HistoryLog(
      expression: textEditingController.text,
      result: _result,
    );
    context.read<HistoryViewModel>().createHistoryLog(newHistoryLog);
    if (_result >= 0) {
      textEditingController.text = numberFormatter.format(_result);
    } else {
      textEditingController.text = CalculatorConstants.space +
          CalculatorConstants.subtraction +
          numberFormatter.format(-_result);
    }
    notifyListeners();
  }

  Future<void> onHistoryButtonTapped(BuildContext context) async {
    final (HistoryLogAction, HistoryLog)? historyLogAction =
        await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const HistoryScreen(),
      ),
    );

    if (historyLogAction == null) {
      return;
    }

    final historyLog = historyLogAction.$2;
    switch (historyLogAction.$1) {
      case HistoryLogAction.replace:
        textEditingController.text = historyLog.expression;
        _result = historyLog.result.toDouble();
        notifyListeners();
      default:
    }
  }

  //TODO: Optimize the old business logic code below

  ///Handles cursor changes
  void _changeText(
      Map<String, Object> Function(String beforeCursor, String afterCursor)
          function,
      {bool backPressed = false}) {
    final text = textEditingController.text;

    int cursorPos = textEditingController.selection.base.offset;
    if (cursorPos == -1) {
      cursorPos = 0;
    } else if (cursorPos > 0 &&
        text[cursorPos - 1] == CalculatorConstants.space) {
      cursorPos--;
    }

    String textBefore = text.substring(0, cursorPos),
        textAfter = text.substring(cursorPos);
    if (textBefore.endsWith(',')) {
      textBefore = textBefore.substring(0, textBefore.length - 1);
    }
    if (textAfter.startsWith(',')) textAfter = textAfter.substring(1);

    if (textBefore.isNotEmpty &&
        textAfter.isNotEmpty &&
        RegExp(r'^[a-zA-Z]$').hasMatch(textBefore[textBefore.length - 1]) &&
        RegExp(r'^[a-zA-Z]$').hasMatch(textAfter[0])) {
      //The cursor is in middle of a function
      if (backPressed) {
        while (cursorPos <= text.length &&
            RegExp(r'^[a-zA-Z]$').hasMatch(text[cursorPos - 1])) {
          cursorPos++;
        }
        cursorPos--;

        textBefore = text.substring(0, cursorPos);
        textAfter = text.substring(cursorPos);
      } else {
        showToast('Invalid Format');
        return;
      }
    }

    final action = function(textBefore, textAfter);
    if (action.isEmpty) return;

    if (action['replace'] != null) {
      String newText = action['replace'] as String;
      cursorPos = text.length - cursorPos;
      textEditingController.text = newText;
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: newText.length - cursorPos));
      return;
    }

    String newText;
    String? toAdd, textBeforeRestore;
    bool splitted = false;
    if (action['add'] != null) {
      toAdd = action['add'] as String;
      textBeforeRestore = textBefore;
      textBefore += toAdd;
      splitted = !RegExp(r'[0-9\.]').hasMatch(toAdd);
    } else {
      textBefore = textBefore.substring(
        0,
        textBefore.length - (action['remove'] as int),
      );
    }

    //Find the string(s) that has to be formatted
    int start = splitted
        ? textBefore.length - toAdd!.length - 1
        : textBefore.length - 1;
    while (start >= 0 && RegExp(r'[0-9\.,]').hasMatch(textBefore[start])) {
      start--;
    }
    start++;

    int end = 0;
    while (end < textAfter.length &&
        RegExp(r'[0-9\.,]').hasMatch(textAfter[end])) {
      end++;
    }
    end--;

    if (splitted) {
      textBefore = textBeforeRestore!;
      String num1 = formatNumberString(textBefore.substring(
            start,
          )),
          num2 = formatNumberString(textAfter.substring(0, end + 1));
      newText = textBefore.substring(0, start) +
          num1 +
          toAdd! +
          num2 +
          textAfter.substring(end + 1);
    } else {
      String formattedNumber = formatNumberString(
        textBefore.substring(start) + textAfter.substring(0, end + 1),
      );
      newText = textBefore.substring(0, start) +
          formattedNumber +
          textAfter.substring(end + 1);
    }

    int charsAfterCursor;
    if (toAdd != null) {
      charsAfterCursor = 0;
      final int nonCommaCharsAfter = textAfter.split(',').join().length;
      int nonCommaFound = 0;
      while (nonCommaFound < nonCommaCharsAfter) {
        if (newText[newText.length - charsAfterCursor - 1] != ',') {
          nonCommaFound++;
        }
        charsAfterCursor++;
      }
    } else {
      int charsBeforeCursor = 0;
      final int nonCommaCharsBefore = textBefore.split(',').join().length;
      int nonCommaFound = 0;
      while (nonCommaFound < nonCommaCharsBefore) {
        if (newText[charsBeforeCursor] != ',') {
          nonCommaFound++;
        }
        charsBeforeCursor++;
      }

      charsAfterCursor = newText.length - charsBeforeCursor;
    }

    //Check if user has somewhere entered more than 10 decimals
    if (!backPressed && RegExp(r'\.\d{11,}').hasMatch(newText)) {
      showToast('You can enter upto 10 decimal places.');
      return;
    }

    //Check if user has somewhere entered more than 15 digits in integral part
    if (!backPressed &&
        RegExp(r'\d{16,}').hasMatch(newText.replaceAll(RegExp(','), ''))) {
      showToast('You can enter upto 15 decimal places.');
      return;
    }

    textEditingController.text = newText;
    if (charsAfterCursor < 0) charsAfterCursor = 0;
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length - charsAfterCursor));

    final hasTrigonometricFunc = _containsTrigometricFunction(newText);
    if (hasTrigonometricFunc != _hasTrigonometricFunction) {
      _hasTrigonometricFunction = hasTrigonometricFunc;
    }

    dev.log('Calculating');
    _result = _evaluator.calculateResult(
      textEditingController.text,
      angleInDegree: _angleInDegree,
    );
    notifyListeners();

    focusNode.unfocus();
    focusNode.requestFocus();
  }

  void addDigit(int digit) {
    _changeText(
      (String beforeCursor, String afterCursor) {
        if (_endsWithDigit(beforeCursor) || _startsWithDigit(afterCursor)) {
          return {'add': '$digit'};
        }

        if (afterCursor.startsWith('(') &&
            (beforeCursor.isEmpty || beforeCursor.endsWith('('))) {
          return {
            'add':
                '$digit${CalculatorConstants.space}${CalculatorConstants.multiplication}'
          };
        }

        if (beforeCursor.isNotEmpty) {
          final lastChar = beforeCursor[beforeCursor.length - 1];
          if (_isUnaryOperator(lastChar) ||
              lastChar == ')' ||
              _isConstant(lastChar)) {
            return {
              'add':
                  '${CalculatorConstants.space}${CalculatorConstants.multiplication}$digit'
            };
          }
          if (_endsWithFunction(beforeCursor) != null) {
            return {'add': '$digit'};
          }
        }

        if (afterCursor.isNotEmpty &&
            (_isConstant(afterCursor[0]) ||
                _startsWithFunction(afterCursor) != null)) {
          return {
            'add':
                '$digit${CalculatorConstants.space}${CalculatorConstants.multiplication}'
          };
        }

        return {'add': '$digit'};
      },
    );
  }

  void _addBinaryOperator(String op) {
    _changeText((String beforeCursor, String afterCursor) {
      if (beforeCursor.isNotEmpty &&
          _isBinaryOperator(beforeCursor[beforeCursor.length - 1])) {
        return {
          'replace': beforeCursor.substring(0, beforeCursor.length - 1) +
              op +
              afterCursor
        };
      }

      if (afterCursor.length >= 2 && _isBinaryOperator(afterCursor[1])) {
        return {
          'replace':
              '$beforeCursor${CalculatorConstants.space}$op${afterCursor.substring(2)}'
        };
      }

      if (beforeCursor.isEmpty) {
        if (op != CalculatorConstants.subtraction) {
          showToast('Invalid Format');
          return {};
        }

        if (afterCursor.isEmpty) {
          return {
            'replace':
                '${CalculatorConstants.space}${CalculatorConstants.subtraction}'
          };
        }

        //beforeCursor is empty, afterCursor is not empty, op is minus
        final firstChar = afterCursor[0];
        if (isDigit(firstChar) ||
            firstChar == '(' ||
            _isConstant(firstChar) ||
            _startsWithFunction(afterCursor) != null) {
          return {
            'replace':
                '${CalculatorConstants.space}${CalculatorConstants.subtraction}$afterCursor'
          };
        } else {
          showToast('InvalidFormat');
          return {};
        }
      }

      if (_endsWithFunction(beforeCursor) != null) {
        showToast('InvalidFormat');
        return {};
      }

      return {'add': '${CalculatorConstants.space}$op'};
    });

    _result = _evaluator.calculateResult(
      textEditingController.text,
      angleInDegree: _angleInDegree,
    );
    notifyListeners();
  }

  void addBracket() {
    _changeText((String beforeCursor, String afterCursor) {
      if (beforeCursor.isEmpty) return {'replace': '($afterCursor'};

      final lastChar = beforeCursor[beforeCursor.length - 1];
      if (_isBinaryOperator(lastChar) ||
          lastChar == '(' ||
          _endsWithFunction(beforeCursor) != null) {
        return {'replace': '$beforeCursor($afterCursor'};
      }

      int bracketBalance = 0;
      for (int i = 0; i < beforeCursor.length; i++) {
        String char = beforeCursor[i];
        if (char == '(') {
          bracketBalance++;
        } else if (char == ')') {
          bracketBalance--;
        }
      }

      if (bracketBalance > 0) {
        //Balance an opening bracket by a closing bracket
        return {'add': ')'};
      }

      if (isDigit(lastChar) ||
          lastChar == '.' ||
          _isUnaryOperator(lastChar) ||
          lastChar == ')' ||
          _isConstant(lastChar)) {
        return {
          'add':
              '${CalculatorConstants.space}${CalculatorConstants.multiplication}('
        };
      }

      return {};
    });
  }

  void addPercentage() => _addUnaryOperator(CalculatorConstants.percentage);
  void addFactorial() => _addUnaryOperator(CalculatorConstants.factorial);

  void _addUnaryOperator(String operator) {
    _changeText((String beforeCursor, String afterCursor) {
      String lastChar =
              beforeCursor.isEmpty ? '' : beforeCursor[beforeCursor.length - 1],
          firstChar = afterCursor.isEmpty ? '' : afterCursor[0];
      if (beforeCursor.isEmpty ||
          _isBinaryOperator(lastChar) ||
          lastChar == operator ||
          lastChar == '(' ||
          _endsWithFunction(beforeCursor) != null ||
          (lastChar == '.' &&
              firstChar != '' &&
              !isDigit(firstChar) &&
              firstChar != ')') ||
          (firstChar == '.' && (isDigit(lastChar) || _isConstant(lastChar)))) {
        showToast('InvalidFormat');
        return {};
      }

      return {'add': operator};
    });
  }

  void addDot() {
    _changeText((String beforeCursor, String afterCursor) {
      String lastChar =
              beforeCursor.isEmpty ? '' : beforeCursor[beforeCursor.length - 1],
          firstChar = afterCursor.isEmpty ? '' : afterCursor[0];

      if (lastChar == '.' || firstChar == '.') {
        return {};
      }

      if (isDigit(lastChar) || isDigit(firstChar)) {
        int numScanIndex = beforeCursor.length - 1;
        while (numScanIndex >= 0 &&
            RegExp(r'[\d,]').hasMatch(beforeCursor[numScanIndex])) {
          numScanIndex--;
        }
        if (numScanIndex >= 0 && beforeCursor[numScanIndex] == '.') {
          return {};
        }

        numScanIndex = 0;
        while (numScanIndex < afterCursor.length &&
            RegExp(r'[\d,]').hasMatch(afterCursor[numScanIndex])) {
          numScanIndex++;
        }
        if (numScanIndex < afterCursor.length &&
            afterCursor[numScanIndex] == '.') {
          return {};
        }

        if (!isDigit(lastChar)) return {'add': '0.'};
        return {'add': '.'};
      }

      if (beforeCursor.isEmpty ||
          lastChar == '(' ||
          _isBinaryOperator(lastChar)) {
        return {'add': '0.'};
      }

      //if (isDigit(lastChar)) return {'add': '.'};

      if (_isUnaryOperator(lastChar) ||
          lastChar == ')' ||
          _isConstant(lastChar)) {
        return {
          'add':
              '${CalculatorConstants.space}${CalculatorConstants.multiplication}0.'
        };
      }

      if (_endsWithFunction(beforeCursor) != null) {
        showToast('InvalidFormat');
      }

      return {};
    });
  }

  void addConstant(String constant) {
    _changeText((String beforeCursor, String afterCursor) {
      if (afterCursor.startsWith('.') && beforeCursor.isNotEmpty) {
        final lastChar = beforeCursor[beforeCursor.length - 1];
        if (lastChar == '.' || _isUnaryOperator(lastChar) || lastChar == ')') {
          showToast('InvalidFormat');
          return {};
        }
      }

      if (_endsWithFunction(beforeCursor) != null) {
        showToast('InvalidFormat');
        return {};
      }

      bool leftMul = false;
      if (beforeCursor.isNotEmpty) {
        final lastChar = beforeCursor[beforeCursor.length - 1];
        leftMul = (isDigit(lastChar) ||
            lastChar == '.' ||
            _isUnaryOperator(lastChar) ||
            lastChar == ')' ||
            _isConstant(lastChar));
      }

      bool rightMul = false;
      if (afterCursor.isNotEmpty) {
        final firstChar = afterCursor[0];
        rightMul = (isDigit(firstChar) ||
            firstChar == '.' ||
            firstChar == '(' ||
            _isConstant(firstChar) ||
            _startsWithFunction(afterCursor) != null);
      }

      String toAdd = constant;
      if (leftMul) {
        toAdd =
            '${CalculatorConstants.space}${CalculatorConstants.multiplication}$toAdd';
      }
      if (rightMul) {
        toAdd +=
            '${CalculatorConstants.space}${CalculatorConstants.multiplication}';
      }

      return {'add': toAdd};
    });
  }

  void addFunction(String func) {
    _changeText((String beforeCursor, String afterCursor) {
      if (afterCursor.startsWith('.') && beforeCursor.isNotEmpty) {
        final lastChar = beforeCursor[beforeCursor.length - 1];
        if (lastChar == '.' || _isUnaryOperator(lastChar) || lastChar == ')') {
          showToast('InvalidFormat');
          return {};
        }
      }

      if (_endsWithFunction(beforeCursor) != null) {
        showToast('InvalidFormat');
        return {};
      }

      bool leftMul = false;
      if (beforeCursor.isNotEmpty) {
        final lastChar = beforeCursor[beforeCursor.length - 1];
        leftMul = (isDigit(lastChar) ||
            lastChar == '.' ||
            _isUnaryOperator(lastChar) ||
            lastChar == ')' ||
            _isConstant(lastChar));
      }

      String toAdd = func;
      if (leftMul) {
        toAdd =
            '${CalculatorConstants.space}${CalculatorConstants.multiplication}$toAdd';
      }
      if (afterCursor.isEmpty || afterCursor[0] != '(') toAdd += '(';

      return {'add': toAdd};
    });
  }

  void onPressBack() {
    _changeText(
      (String beforeCursor, String afterCursor) {
        if (beforeCursor.isEmpty) {
          return {};
        }

        final beforeLength = beforeCursor.length;
        String lastChar = beforeCursor[beforeLength - 1];
        if (isDigit(lastChar) ||
            lastChar == '.' ||
            _isUnaryOperator(lastChar) ||
            lastChar == ')' ||
            _isConstant(lastChar)) {
          return {'remove': 1};
        }

        if (_isBinaryOperator(lastChar)) {
          return {'remove': min(beforeLength, 2)};
        }

        int index = beforeLength;
        if (lastChar == '(') {
          index--;
          beforeCursor = beforeCursor.substring(0, beforeLength - 1);
        }

        final String? beforeEndsWithFunction = _endsWithFunction(beforeCursor);
        if (beforeEndsWithFunction != null) {
          index -= beforeEndsWithFunction.length;
        }

        return {'remove': beforeLength - index};
      },
      backPressed: true,
    );
  }

  void onLongPressBack() {
    _changeText(
      (String beforeCursor, String afterCursor) =>
          {'remove': beforeCursor.length},
      backPressed: true,
    );
  }

  bool _isConstant(String str) => ScientificConstants.constants.contains(str);
  bool _isUnaryOperator(String str) =>
      CalculatorConstants.unaryOperators.contains(str);

  bool _isBinaryOperator(String str) => <String>[
        CalculatorConstants.addition,
        CalculatorConstants.subtraction,
        CalculatorConstants.multiplication,
        CalculatorConstants.division,
        CalculatorConstants.power
      ].contains(str);

  ///Tells if string [str] starts with a digit
  bool _startsWithDigit(String str) =>
      (str.isNotEmpty && RegExp(r'^\d$').hasMatch(str[0]));

  ///Tells if string [str] ends with a digit
  bool _endsWithDigit(String str) =>
      (str.isNotEmpty && RegExp(r'^\d$').hasMatch(str[str.length - 1]));

  String? _startsWithFunction(String str) {
    if (str.isEmpty) return null;
    for (final func in ScientificFunctions.functionNames) {
      if (str.startsWith(func)) return func;
    }
    return null;
  }

  String? _endsWithFunction(String str) {
    if (str.isEmpty) return null;

    String longest = '';
    for (final func in ScientificFunctions.functionNames) {
      if (str.endsWith(func) && func.length > longest.length) {
        longest = func;
      }
    }

    return longest.isEmpty ? null : longest;
  }

  bool _containsTrigometricFunction(String newText) {
    return [
      ...ScientificFunctions.trigonometric,
      ...ScientificFunctions.trigonometricInverses
    ].any((func) => newText.contains('$func('));
  }
}
