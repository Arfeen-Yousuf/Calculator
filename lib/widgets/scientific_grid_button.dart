import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

import 'grid_button.dart';

class ScientificGridButton extends StatelessWidget {
  const ScientificGridButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;

    return GridButton(
      onPressed: onPressed,
      text: text,
      backgroundColor: appColors.gridScientificButtonBackground,
    );
  }
}
