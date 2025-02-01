import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

class MySwitch extends StatelessWidget {
  const MySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Theme(
      data: ThemeData(useMaterial3: false),
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: appColors.primary,
      ),
    );
  }
}
