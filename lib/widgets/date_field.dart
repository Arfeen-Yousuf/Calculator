import 'package:calculator/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'svg_icon.dart';

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    this.label,
    this.dateTime,
    this.onDateTimeChanged,
  });

  final String? label;
  final DateTime? dateTime;
  final ValueChanged<DateTime>? onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    late final labelStyle =
        TextTheme.of(context).labelMedium?.copyWith(fontSize: 18);
    const dateTimeTextStyle = TextStyle(fontSize: 18);
    final hintTextStyle = TextStyle(
      fontSize: 18,
      color: Colors.grey[500],
    );

    final listTileTitle = (dateTime != null)
        ? Text(
            dateToString(dateTime)!,
            style: dateTimeTextStyle,
          )
        : Text(
            'MMM dd, yyyy',
            style: hintTextStyle,
          );
    final listTile = ListTile(
      title: listTileTitle,
      trailing: const SvgIcon(SvgIconData.calendar),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 8,
      ),
      onTap:
          (onDateTimeChanged == null) ? null : () => _showDatePicker(context),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (label != null) Text(label!, style: labelStyle),
        listTile,
      ],
    );
  }

  void _showDatePicker(BuildContext context) async {
    //TODO: Decide between the two alternative choices

    _showDialog(
      context,
      CupertinoDatePicker(
        initialDateTime: dateTime ?? DateTime.now(),
        minimumDate: DateTime(1900),
        maximumDate: DateTime(2100, 12, 31),
        mode: CupertinoDatePickerMode.date,
        use24hFormat: true,
        // This shows day of week alongside day of month
        showDayOfWeek: true,
        // This is called when the user changes the date.
        onDateTimeChanged: onDateTimeChanged!,
      ),
    );

    /*
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
    );
    if (pickedDate != null) onDateTimeChanged(pickedDate);
    */
  }

  void _showDialog(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
