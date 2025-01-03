import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

class NumberTextField extends StatelessWidget {
  const NumberTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    late final labelStyle =
        TextTheme.of(context).labelMedium?.copyWith(fontSize: 18);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (label != null) Text(label!, style: labelStyle),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.none,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 20),
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 16),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: appColors.primary ?? Colors.black,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
