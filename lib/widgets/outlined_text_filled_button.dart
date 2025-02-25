import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

class OutlinedTextFilledButton extends StatelessWidget {
  const OutlinedTextFilledButton({
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

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        foregroundColor: isLightTheme ? appColors.primary : Colors.white,
        backgroundColor: isLightTheme
            ? appColors.scaffoldBackground
            : appColors.gridButtonDefaultBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: isLightTheme
            ? BorderSide(color: Colors.grey[400]!)
            : BorderSide.none,
        splashFactory: InkSplash.splashFactory,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(text),
      ),
    );
  }
}
