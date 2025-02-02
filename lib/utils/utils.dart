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

bool isSimpleNumber(String str) {
  final invalidCharacterRegExp = RegExp(r'[^0-9,\.]');
  return !invalidCharacterRegExp.hasMatch(str);
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
