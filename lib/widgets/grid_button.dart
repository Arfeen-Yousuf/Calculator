import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

import 'svg_icon.dart';

class GridButton extends StatelessWidget {
  ///Exactly one of [text], [iconData], [svgIconData] must be provided
  const GridButton({
    super.key,
    this.onPressed,
    this.text,
    this.iconData,
    this.svgIconData,
    this.foregroundColor,
    this.backgroundColor,
    this.largeFontSize = false,
  });

  final VoidCallback? onPressed;
  final String? text;
  final IconData? iconData;
  final SvgIconData? svgIconData;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool largeFontSize;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        foregroundColor: foregroundColor ?? appColors.primaryText,
        backgroundColor:
            backgroundColor ?? appColors.gridButtonDefaultBackground,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        splashFactory: InkSplash.splashFactory,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (text != null) {
            return Text(
              text!,
              style: TextStyle(
                fontSize: constraints.maxHeight * (largeFontSize ? 0.6 : 0.45),
              ),
              softWrap: false,
            );
          } else if (iconData != null) {
            return Icon(
              iconData,
              size: constraints.maxHeight * 0.4,
              color: foregroundColor ?? appColors.primary,
            );
          } else {
            return SvgIcon(
              svgIconData!,
              size: constraints.maxHeight * 0.4,
              color: foregroundColor ?? appColors.primary,
            );
          }
        },
      ),
    );
  }
}
