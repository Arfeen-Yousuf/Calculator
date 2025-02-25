import 'dart:math';

import 'package:calculator/utils/constants.dart';
import 'package:flutter/services.dart';

class MyThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    if (newText.isEmpty || newText == '-') return newValue;

    //Count how many non comma characters after the cursor
    int cursorPos = newValue.selection.baseOffset;
    if (cursorPos == -1) cursorPos = 0;

    final isNegativeValue = newText.startsWith('-');
    if (isNegativeValue) {
      newText = newText.substring(1);
      cursorPos--;
      if (cursorPos == -1) cursorPos = 0;
    }

    int nonCommaAfterCursor =
        newText.substring(cursorPos).replaceAll(',', '').length;
    String formattedString = formatNumberString(newText);

    final dotIndex = formattedString.indexOf('.');
    if (dotIndex == -1) {
      cursorPos = (4 * (nonCommaAfterCursor ~/ 3)) + (nonCommaAfterCursor % 3);
    } else {
      final decimalPartLength = formattedString.length - dotIndex;
      if (nonCommaAfterCursor <= decimalPartLength) {
        cursorPos = nonCommaAfterCursor;
      } else {
        cursorPos = decimalPartLength;
        nonCommaAfterCursor -= decimalPartLength;
        cursorPos +=
            (4 * (nonCommaAfterCursor ~/ 3)) + (nonCommaAfterCursor % 3);
      }
    }

    if (isNegativeValue) formattedString = '-$formattedString';

    return TextEditingValue(
      text: formattedString,
      selection: TextSelection.collapsed(
        offset: max(0, formattedString.length - cursorPos),
      ),
    );
  }
}

String formatNumberString(String num) {
  if (num.isEmpty) return num;
  num = num.replaceAll(',', '');
  if (num[0] == '.') return num;

  final dotIndex = num.indexOf('.');
  if (dotIndex != -1) {
    final integralPart = num.substring(0, dotIndex);
    return formatWithComma(integralPart) + num.substring(dotIndex);

    //double d = double.parse(num.substring(0, dotIndex));
    //return numberFormatter.format(d) + num.substring(dotIndex);
  }

  return formatWithComma(num);
}

String formatWithComma(String input) {
  final bool isNegativeValue;

  if (input.startsWith(CalculatorConstants.subtraction)) {
    isNegativeValue = true;
    input = input.substring(1);
  } else {
    isNegativeValue = false;
  }

  // Remove any existing separators (optional, if required)
  String cleanedInput = input.replaceAll(RegExp(','), '');

  // Reverse the string, split into groups of three, then reverse again
  String formatted = cleanedInput
      .split('')
      .reversed
      .join()
      .replaceAllMapped(RegExp(r'.{1,3}'), (match) => '${match.group(0)},')
      .split('')
      .reversed
      .join();

  // Remove any leading separator
  if (formatted.startsWith(',')) {
    formatted = formatted.substring(1);
  }

  return isNegativeValue
      ? CalculatorConstants.subtraction + formatted
      : formatted;
}
