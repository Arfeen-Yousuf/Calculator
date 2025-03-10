import 'dart:async';

import 'package:calculator/enums/history_log_action.dart';
import 'package:calculator/extensions/string.dart';
import 'package:calculator/providers/settings_provider.dart';
import 'package:calculator/screens/history/history_screen.dart';
import 'package:calculator/screens/history/history_view_model.dart';
import 'package:calculator/services/history_database.dart';
import 'package:calculator/utils/constants.dart';
import 'package:calculator/utils/expression_evaluator.dart';
import 'package:calculator/utils/utils.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

import 'formatters/thousands_formatter.dart';

class CalculatorViewModel extends ChangeNotifier {
  final BuildContext context;
  final bool isInBottomSheet;

  CalculatorViewModel(
    this.context, {
    required this.isInBottomSheet,
  }) {
    _initializeController(context);

    // Listen for theme changes dynamically
    final settingsProvider = context.read<SettingsProvider>();
    settingsProvider.addListener(
      () => _updateControllerTextStyles(context),
    );
    if (!isInBottomSheet) _setInitialExpression();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _initializeController(
    BuildContext context, {
    String? initialText,
  }) {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    _textEditingController = RichTextController(
      text: initialText,
      onMatch: (List<String> matches) {},
      targetMatches: <String>{
        CalculatorConstants.percentage,
        CalculatorConstants.division,
        CalculatorConstants.multiplication,
        CalculatorConstants.subtraction,
        CalculatorConstants.addition,
        CalculatorConstants.power,
      }
          .map(
            (char) => MatchTargetItem(
              text: char,
              allowInlineMatching: true,
              style: TextStyle(color: settingsProvider.themeColor.color),
            ),
          )
          .toList(),
    );
  }

  void _updateControllerTextStyles(BuildContext context) {
    _initializeController(
      context,
      initialText: _textEditingController.text,
    );
    notifyListeners();
  }

  void _setInitialExpression() {
    final settingsProvider = context.read<SettingsProvider>();
    if (settingsProvider.keepLastRecord) {
      final lastExpr = settingsProvider.lastExpression;
      _textEditingController.text = lastExpr;
      if (containsTrigometricFunction(lastExpr)) {
        _isScientific = true;
        _hasTrigonometricFunction = true;
        notifyListeners();
      }

      _calculateResult();
    }
  }

  late RichTextController _textEditingController;
  RichTextController get textEditingController => _textEditingController;
  String get currentExpression => _textEditingController.text;

  final focusNode = FocusNode();
  final _evaluator = ExpressionEvaluator();

  bool _isScientific = false;
  get isScientific => _isScientific;
  void setIsScientific(bool isScientific) {
    if (_isScientific == isScientific) return;
    _isScientific = isScientific;
    notifyListeners();
  }

  void toogleScientific() {
    _isScientific = !_isScientific;
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
    _calculateResult();
  }

  bool _hasTrigonometricFunction = false;
  bool get hasTrigonometricFunction => _hasTrigonometricFunction;
  void setHasTrigometricFunc(bool value) {
    if (_hasTrigonometricFunction == value) return;
    _hasTrigonometricFunction = value;
    notifyListeners();
  }

  Decimal? _result;
  Decimal? get result => _result;

  bool _isCalculating = false;
  bool get isCalculating => _isCalculating;

  String? _error;
  String? get error => _error;

  void clear() {
    _textEditingController.clear();
    _result = null;
    _error = null;
    _hasTrigonometricFunction = false;
    notifyListeners();
  }

  void onEqualPressed() {
    if (_error != null || _result == null) {
      showToast(_error ?? AppStrings.invalidFormat);
      return;
    }

    if (isSimpleNumber(_textEditingController.text)) {
      if (isInBottomSheet) {
        Navigator.pop<String>(
          context,
          _textEditingController.text,
        );
      }

      return;
    }

    final formattedResult = formatDecimal(
      _result!,
      decimalPlaces: context.read<SettingsProvider>().decimalPlaces,
      inScientificNotation: !isInBottomSheet,
    );
    if (isInBottomSheet) {
      Navigator.pop<String>(context, formattedResult);
      return;
    }

    final newHistoryLog = HistoryLog(
      expression: _textEditingController.text,
      result: formattedResult,
    );
    context.read<HistoryViewModel>().createHistoryLog(newHistoryLog);
    _textEditingController.text = formattedResult;

    notifyListeners();
  }

  void _calculateResult() {
    _calculateResultAsync();
  }

  void _calculateResultAsync() async {
    _result = null;
    _isCalculating = true;
    notifyListeners();

    try {
      final expr = _textEditingController.text;
      _result = await _evaluator.calculateResult(
        expr,
        angleInDegree: _angleInDegree,
      );
      _error = null;
    } on Error catch (e) {
      _result = null;
      _error = switch (e) {
        ArgumentError(:var message) => message,
        StateError(:var message) => message,
        _ => 'An error occurred.'
      };
    } on Exception {
      _result = null;
      _error = AppStrings.invalidFormat;
    }

    if (_error == 'Invalid value') {
      _error = AppStrings.invalidFormat;
    }
    _isCalculating = false;
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
    if (historyLogAction.$1 == HistoryLogAction.replace) {
      _textEditingController.text = historyLog.expression;
      _calculateResult();
    }
  }

  // Binary operators
  void addDivision() => _addBinaryOperator(CalculatorConstants.division);
  void addMultiplication() =>
      _addBinaryOperator(CalculatorConstants.multiplication);
  void addSubtraction() => _addBinaryOperator(CalculatorConstants.subtraction);
  void addAddition() => _addBinaryOperator(CalculatorConstants.addition);
  void addPower() => _addBinaryOperator(CalculatorConstants.power);

  ///Handles cursor changes
  void _changeText(
    Map<String, Object> Function(String beforeCursor, String afterCursor)
        function, {
    bool backPressed = false,
  }) {
    _error = null;

    final text = _textEditingController.text;

    int cursorPos = _textEditingController.selection.base.offset;
    if (cursorPos == -1) {
      cursorPos = 0;
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
        showToast(AppStrings.invalidFormat);
        return;
      }
    }

    final action = function(textBefore, textAfter);
    if (action.isEmpty) return;

    if (action['replace'] != null) {
      String newText = action['replace'] as String;
      cursorPos = text.length - cursorPos;
      _textEditingController.text = newText;
      _textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length - cursorPos),
      );
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

    _textEditingController.text = newText;
    if (charsAfterCursor < 0) charsAfterCursor = 0;
    _textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length - charsAfterCursor));

    final hasTrigonometricFunc = containsTrigometricFunction(newText);
    if (hasTrigonometricFunc != _hasTrigonometricFunction) {
      _hasTrigonometricFunction = hasTrigonometricFunc;
    }

    focusNode.unfocus();
    Future.delayed(
      const Duration(milliseconds: 5),
      () {
        focusNode.requestFocus();
      },
    );

    _calculateResult();
  }

  void addDigit(int digit) {
    _changeText(
      (String beforeCursor, String afterCursor) {
        if (beforeCursor.last.isDigit || afterCursor.first.isDigit) {
          return {'add': '$digit'};
        }

        if (afterCursor.startsWith('(') &&
            (beforeCursor.isEmpty || beforeCursor.endsWith('('))) {
          return {'add': '$digit${CalculatorConstants.multiplication}'};
        }

        if (beforeCursor.isNotEmpty) {
          final lastChar = beforeCursor[beforeCursor.length - 1];
          if (_isUnaryOperator(lastChar) ||
              lastChar == ')' ||
              _isConstant(lastChar)) {
            return {'add': '${CalculatorConstants.multiplication}$digit'};
          }
          if (_endsWithFunction(beforeCursor) != null) {
            return {'add': '$digit'};
          }
        }

        if (afterCursor.isNotEmpty &&
            (_isConstant(afterCursor[0]) ||
                _startsWithFunction(afterCursor) != null)) {
          return {'add': '$digit${CalculatorConstants.multiplication}'};
        }

        return {'add': '$digit'};
      },
    );
  }

  void _addBinaryOperator(String op) {
    _changeText((String beforeCursor, String afterCursor) {
      if (_isBinaryOperator(beforeCursor.last)) {
        return {'replace': beforeCursor.removeLast() + op + afterCursor};
      }

      if (afterCursor.isNotEmpty && _isBinaryOperator(afterCursor[0])) {
        return {'replace': beforeCursor + op + afterCursor.substring(1)};
      }

      if (beforeCursor.isEmpty) {
        if (op != CalculatorConstants.subtraction) {
          showToast(AppStrings.invalidFormat);
          return {};
        }

        if (afterCursor.isEmpty) {
          return {'replace': CalculatorConstants.subtraction};
        }

        //beforeCursor is empty, afterCursor is not empty, op is minus
        final firstChar = afterCursor[0];
        if (firstChar.isDigit ||
            firstChar == '(' ||
            _isConstant(firstChar) ||
            _startsWithFunction(afterCursor) != null) {
          return {'replace': '${CalculatorConstants.subtraction}$afterCursor'};
        } else {
          showToast(AppStrings.invalidFormat);
          return {};
        }
      }

      if (_endsWithFunction(beforeCursor) != null) {
        showToast(AppStrings.invalidFormat);
        return {};
      }

      return {'add': op};
    });

    _calculateResult();
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

      if (lastChar.isDigit ||
          lastChar == '.' ||
          _isUnaryOperator(lastChar) ||
          lastChar == ')' ||
          _isConstant(lastChar)) {
        return {'add': '${CalculatorConstants.multiplication}('};
      }

      return {};
    });
  }

  void addPercentage() => _addUnaryOperator(CalculatorConstants.percentage);
  void addFactorial() => _addUnaryOperator(CalculatorConstants.factorial);

  void _addUnaryOperator(String operator) {
    _changeText((String beforeCursor, String afterCursor) {
      final lastChar = beforeCursor.last;
      final firstChar = afterCursor.isEmpty ? '' : afterCursor[0];
      if (_isUnaryOperator(lastChar) || _isUnaryOperator(firstChar)) {
        showToast(AppStrings.invalidFormat);
        return {};
      }
      if (beforeCursor.isEmpty ||
          _isBinaryOperator(lastChar) ||
          lastChar == operator ||
          lastChar == '(' ||
          _endsWithFunction(beforeCursor) != null ||
          (lastChar == '.' &&
              firstChar != '' &&
              !firstChar.isDigit &&
              firstChar != ')') ||
          (firstChar == '.' && (lastChar.isDigit || _isConstant(lastChar)))) {
        showToast(AppStrings.invalidFormat);
        return {};
      }

      return {'add': operator};
    });
  }

  void addDot() {
    _changeText((String beforeCursor, String afterCursor) {
      String lastChar = beforeCursor.last;
      String firstChar = afterCursor.first;

      if (lastChar == '.' || firstChar == '.') {
        return {};
      }

      if (lastChar.isDigit || firstChar.isDigit) {
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

        return {'add': lastChar.isDigit ? '.' : '0.'};
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
        return {'add': '${CalculatorConstants.multiplication}0.'};
      }

      if (_endsWithFunction(beforeCursor) != null) {
        showToast(AppStrings.invalidFormat);
      }

      return {};
    });
  }

  void addConstant(String constant) {
    _changeText((String beforeCursor, String afterCursor) {
      if (afterCursor.startsWith('.') && beforeCursor.isNotEmpty) {
        final lastChar = beforeCursor.last;
        if (lastChar == '.' || _isUnaryOperator(lastChar) || lastChar == ')') {
          showToast(AppStrings.invalidFormat);
          return {};
        }
      }

      if (_endsWithFunction(beforeCursor) != null) {
        showToast(AppStrings.invalidFormat);
        return {};
      }

      bool leftMul = false;
      if (beforeCursor.isNotEmpty) {
        final lastChar = beforeCursor[beforeCursor.length - 1];
        leftMul = (lastChar.isDigit ||
            lastChar == '.' ||
            _isUnaryOperator(lastChar) ||
            lastChar == ')' ||
            _isConstant(lastChar));
      }

      bool rightMul = false;
      if (afterCursor.isNotEmpty) {
        final firstChar = afterCursor[0];
        rightMul = (firstChar.isDigit ||
            firstChar == '.' ||
            firstChar == '(' ||
            _isConstant(firstChar) ||
            _startsWithFunction(afterCursor) != null);
      }

      String toAdd = constant;
      if (leftMul) {
        toAdd = '${CalculatorConstants.multiplication}$toAdd';
      }
      if (rightMul) {
        toAdd += CalculatorConstants.multiplication;
      }

      return {'add': toAdd};
    });
  }

  void addFunction(String func) {
    _changeText((String beforeCursor, String afterCursor) {
      if (afterCursor.startsWith('.') && beforeCursor.isNotEmpty) {
        final lastChar = beforeCursor.last;
        if (lastChar == '.' || _isUnaryOperator(lastChar) || lastChar == ')') {
          showToast(AppStrings.invalidFormat);
          return {};
        }
      }

      if (_endsWithFunction(beforeCursor) != null) {
        showToast(AppStrings.invalidFormat);
        return {};
      }

      bool leftMul = false;
      if (beforeCursor.isNotEmpty) {
        final lastChar = beforeCursor[beforeCursor.length - 1];
        leftMul = (lastChar.isDigit ||
            lastChar == '.' ||
            _isUnaryOperator(lastChar) ||
            lastChar == ')' ||
            _isConstant(lastChar));
      }

      String toAdd = func;
      if (leftMul) {
        toAdd = '${CalculatorConstants.multiplication}$toAdd';
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
        String lastChar = beforeCursor.last;
        if (lastChar.isDigit ||
            lastChar == '.' ||
            _isUnaryOperator(lastChar) ||
            lastChar == ')' ||
            _isConstant(lastChar)) {
          return {'remove': 1};
        }

        if (_isBinaryOperator(lastChar)) {
          return {'remove': 1};
        }

        int index = beforeLength;
        if (lastChar == '(') {
          index--;
          beforeCursor = beforeCursor.removeLast();
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

  static bool _isConstant(String str) =>
      ScientificConstants.constants.contains(str);
  static bool _isUnaryOperator(String str) =>
      CalculatorConstants.unaryOperators.contains(str);

  static bool _isBinaryOperator(String str) => <String>[
        CalculatorConstants.addition,
        CalculatorConstants.subtraction,
        CalculatorConstants.multiplication,
        CalculatorConstants.division,
        CalculatorConstants.power
      ].contains(str);

  static String? _startsWithFunction(String str) {
    if (str.isEmpty) return null;
    for (final func in ScientificFunctions.functionNames) {
      if (str.startsWith(func)) return func;
    }
    return null;
  }

  static String? _endsWithFunction(String str) {
    if (str.isEmpty) return null;

    String longest = '';
    for (final func in ScientificFunctions.functionNames) {
      if (str.endsWith(func) && func.length > longest.length) {
        longest = func;
      }
    }

    return longest.isEmpty ? null : longest;
  }
}
