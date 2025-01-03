import 'package:calculator/utils/ui_helper.dart';
import 'package:flutter/material.dart';

import 'number_text_field.dart';

class TextFieldWithOptions extends StatelessWidget {
  const TextFieldWithOptions({
    super.key,
    this.controller,
    this.focusNode,
    this.title,
    required this.currentOption,
    required this.options,
    required this.onOptionSelected,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? title;
  final String currentOption;
  final List<String> options;
  final void Function(int index) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton.tonalIcon(
          onPressed: () => _showOptionsBottomModalSheet(context),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
          ),
          label: Text(
            currentOption,
            style: TextTheme.of(context).labelMedium?.copyWith(fontSize: 18),
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            size: 30,
          ),
          iconAlignment: IconAlignment.end,
        ),
        NumberTextField(
          controller: controller,
          focusNode: focusNode,
        ),
      ],
    );
  }

  void _showOptionsBottomModalSheet(BuildContext context) async {
    await showOptionsBottomSheet(
      context,
      title: title,
      options: options,
      currentOption: currentOption,
      onOptionSelected: onOptionSelected,
    );
  }
}
