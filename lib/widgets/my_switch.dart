import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

class MySwitch extends StatefulWidget {
  const MySwitch({
    super.key,
    this.onChanged,
  });

  final void Function(bool)? onChanged;

  @override
  State<MySwitch> createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Theme(
      data: ThemeData(useMaterial3: false),
      child: Switch(
        value: isSwitched,
        onChanged: (value) {
          widget.onChanged?.call(value);
          setState(() {
            isSwitched = value;
          });
        },
        activeColor: appColors.primary,
      ),
    );
  }
}
