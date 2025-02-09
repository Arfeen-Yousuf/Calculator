import 'package:calculator/utils/constants.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void showToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      fontSize: 16,
    );

DateTime truncateDateTime(DateTime dateTime) => DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

final List<String> months = List.generate(
  12,
  (index) => DateFormat.MMM().format(DateTime(0, index + 1)),
);

String? dateToString(DateTime? date) {
  if (date == null) return null;
  return DateFormat('MMM dd, yyyy').format(date);
}

///Format a number upto 5 decimal places
final numberFormatter = NumberFormat('#,##0.#####');

///Format a number upto 8 decimal places
final numberFormatterMedium = NumberFormat('#,##0.########');

///Format a number upto 10 decimal places
final numberFormatterLong = NumberFormat('#,##0.############');

NumberFormat createNumberFormat(int decimalPlaces) {
  return (decimalPlaces == 0)
      ? NumberFormat('#,##0')
      : NumberFormat('#,##0.${'#' * decimalPlaces}');
}

String formatNumber(
  num result, {
  required int decimalPlaces,
}) {
  final numberFormat = createNumberFormat(decimalPlaces);
  return numberFormat.format(result);
}

String formatDecimal(
  Decimal d, {
  required int decimalPlaces,
}) {
  if (d.sign == 0) return '0';
  Decimal absoluteVal = d.abs();

  //If the decimal is too large or small, return scientific notation
  final tenPower15 = Decimal.ten.pow(15).toDecimal();
  late final tenPowerMinus8 = Decimal.ten.pow(-8).toDecimal();
  if (absoluteVal > tenPower15 || absoluteVal < tenPowerMinus8) {
    String absValStr = absoluteVal.toStringAsExponential(decimalPlaces);

    String basePart, expPart;
    [basePart, expPart] = absValStr.split('e');

    // Remove unnecessary trailing zeros from the base part
    basePart = basePart.replaceAll(RegExp(r'0+$'), '');
    if (basePart.endsWith('.')) {
      basePart = basePart.substring(0, basePart.length - 1);
    }

    String absolueValFormatted;
    if (expPart[0] == '-') {
      absolueValFormatted = '$basePart${CalculatorConstants.multiplication}'
          '10${CalculatorConstants.power}($expPart)';
    } else {
      absolueValFormatted = '$basePart${CalculatorConstants.multiplication}'
          '10${CalculatorConstants.power}${expPart.substring(1)}';
    }

    return (d.sign == -1)
        ? CalculatorConstants.subtraction + absolueValFormatted
        : absolueValFormatted;
    //1.34984321 x 10^(12)
  }

  Decimal rounded = absoluteVal.round(scale: decimalPlaces);
  String decimalString = rounded.toString();
  List<String> parts = decimalString.split('.');

  // Remove unnecessary trailing zeros from the fractional part
  if (parts.length > 1) {
    String fractionalPart = parts[1].replaceAll(RegExp(r'0+$'), '');
    if (fractionalPart.isEmpty) {
      parts.removeAt(1); // Remove the fractional part if it's empty
    } else {
      parts[1] = fractionalPart; // Update the fractional part
    }
  }

  // Format the integer part with thousands separators
  String integerPart = parts[0];
  String formattedInteger = _addThousandsSeparator(integerPart);

  // Combine the formatted integer and fractional parts
  String absolueValFormatted =
      (parts.length == 1) ? formattedInteger : '$formattedInteger.${parts[1]}';
  return (d.sign == -1)
      ? CalculatorConstants.subtraction + absolueValFormatted
      : absolueValFormatted;
}

String _addThousandsSeparator(String integerPart) {
  // Add thousands separators to the integer part
  String result = '';
  int length = integerPart.length;
  for (int i = 0; i < length; i++) {
    if ((length - i) % 3 == 0 && i != 0) {
      result += ','; // Add a comma every 3 digits
    }
    result += integerPart[i];
  }
  return result;
}

bool isSimpleNumber(String str) {
  final invalidCharacterRegExp = RegExp(r'[^0-9,\.]');
  return !invalidCharacterRegExp.hasMatch(str);
}

bool containsTrigometricFunction(String newText) {
  return [
    ...ScientificFunctions.trigonometric,
    ...ScientificFunctions.trigonometricInverses
  ].any((func) => newText.contains('$func('));
}

double roundToDecimalPlaces(
  double value,
  int decimalPlaces,
) =>
    double.parse(value.toStringAsFixed(decimalPlaces));

String enumToNormal(Enum input) {
  final inputStr = '$input';
  final dotIndex = inputStr.indexOf('.');
  return camelCaseToNormal(inputStr.substring(dotIndex + 1));
}

List<String> enumListToNormal(List<Enum> enumValues) =>
    enumValues.map(enumToNormal).toList();

String camelCaseToNormal(String input) {
  // Add a space before each uppercase letter except the first one
  String spaced = input.replaceAllMapped(
    RegExp(r'(?<!^)([A-Z])'),
    (match) => ' ${match.group(1)}',
  );

  // Convert the first letter to uppercase and the rest to lowercase
  return spaced[0].toUpperCase() + spaced.substring(1).toLowerCase();
}

Future<void> copyTextToClipboard(String str) async =>
    await Clipboard.setData(ClipboardData(text: str));
