import 'package:calculator/utils/utils.dart';
import 'package:flutter/material.dart';

class DateText extends StatelessWidget {
  const DateText({
    super.key,
    required this.dateTime,
    this.style,
  });

  final DateTime dateTime;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final String toShow;
    final now = truncateDateTime(DateTime.now());
    final truncatedDate = truncateDateTime(dateTime);

    if (now.isAtSameMomentAs(truncatedDate)) {
      toShow = 'Today';
    } else if (now.difference(truncatedDate).inDays == 1) {
      toShow = 'Yesterday';
    } else {
      toShow = dateToString(dateTime);
    }

    return Text(toShow, style: style);
  }
}
