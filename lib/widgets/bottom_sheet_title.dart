import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    super.key,
    this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Row(
      children: [
        if (title != null)
          Text(
            title!,
            style: TextTheme.of(context).labelLarge?.copyWith(fontSize: 20),
          ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close,
            color: isLightTheme ? Colors.black : Colors.white,
          ),
        ),
      ],
    );
  }
}
