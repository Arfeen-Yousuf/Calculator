import 'package:flutter/material.dart';

import 'package:calculator/app/colors.dart';
import 'svg_icon.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  final SvgIconData? leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return ListTile(
      leading: (leading != null)
          ? SvgIcon(
              leading!,
              color: appColors.primary,
              size: 25,
            )
          : null,
      title: Text(title),
      subtitle: (subtitle == null) ? null : Text(subtitle!),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
