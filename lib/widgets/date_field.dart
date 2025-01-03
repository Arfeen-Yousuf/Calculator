import 'dart:math';

import 'package:calculator/app/colors.dart';
import 'package:calculator/utils/utils.dart';
import 'package:flutter/material.dart';

import 'svg_icon.dart';

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    this.label,
    this.dateTime,
  });

  final String? label;
  final DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    late final isLightTheme = Theme.of(context).brightness == Brightness.light;

    late final labelStyle =
        TextTheme.of(context).labelMedium?.copyWith(fontSize: 18);
    const dateTimeTextStyle = TextStyle(fontSize: 18);
    final hintTextStyle = TextStyle(
      fontSize: 18,
      color: Colors.grey[500],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (label != null) Text(label!, style: labelStyle),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.grey,
              width: 1.3,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              (dateTime != null)
                  ? Text(
                      dateToString(dateTime!),
                      style: dateTimeTextStyle,
                    )
                  : Text(
                      'MMM dd, yyyy',
                      style: hintTextStyle,
                    ),
              const SvgIcon(SvgIconData.calendar),
            ],
          ),
        ),
      ],
    );
  }
}
