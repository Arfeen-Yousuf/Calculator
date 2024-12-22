import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

import 'grid_button.dart';

class OperatorGridButton extends StatelessWidget {
  const OperatorGridButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;

    return GridButton(
      onPressed: onPressed,
      text: text,
      foregroundColor: appColors.primary,
      backgroundColor: isLightTheme
          ? appColors.primary?.withAlpha(25)
          : AppColorsDark.gridButtonDefaultBackground,
      largeFontSize: true,
    );
  }
}
