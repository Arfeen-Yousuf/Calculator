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
