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
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: appColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        splashFactory: InkSplash.splashFactory,
      ),
      child: Text(text),
    );
  }
}
