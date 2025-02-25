import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

class PrimaryTextFilledButton extends StatelessWidget {
  const PrimaryTextFilledButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        foregroundColor: isLightTheme ? Colors.white : Colors.black,
        backgroundColor: appColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        splashFactory: InkSplash.splashFactory,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(text),
      ),
    );
  }
}
