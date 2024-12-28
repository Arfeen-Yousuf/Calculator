import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void showToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
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

String dateToString(DateTime date) => DateFormat('MMM dd, yyyy').format(date);

final numberFormatter = NumberFormat('#,##0.#####');
final numberFormatterLong = NumberFormat('#,##0.############');

bool isSimpleNumber(String str) {
  final invalidCharacterRegExp = RegExp(r'[^0-9,\.]');
  return !invalidCharacterRegExp.hasMatch(str);
}

double? roundToDecimalPlaces(
  double value,
  int decimalPlaces,
) =>
    double.parse(value.toStringAsFixed(decimalPlaces));

String enumToNormal(String input) {
  final dotIndex = input.indexOf('.');
  return camelCaseToNormal(input.substring(dotIndex + 1));
}

List<String> enumListToNormal(List<dynamic> enumValues) {
  return enumValues.map((e) => enumToNormal('$e')).toList();
}

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
