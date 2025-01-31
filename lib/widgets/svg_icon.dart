import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const _assetsBasePath = 'assets/svg_icons/';

enum SvgIconData {
  calendar('calendar'),
  fuel('fuel'),
  length('length'),
  mass('mass'),
  area('area'),
  volume('volume'),
  time('time'),
  speed('speed'),
  temperature('temperature'),
  data('data'),
  ruler('ruler'),
  discount('discount'),
  settings('settings'),
  display('display'),
  theme('theme'),
  star('star'),
  share('share'),
  security('security');

  const SvgIconData(String name) : path = '$_assetsBasePath$name.svg';
  final String path;
}

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.iconData, {
    super.key,
    this.size,
    this.color,
  });

  final SvgIconData iconData;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    late final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final svgColor = color ?? (isLightTheme ? Colors.black : Colors.white);

    return SvgPicture.asset(
      iconData.path,
      height: size,
      width: size,
      colorFilter: ColorFilter.mode(svgColor, BlendMode.srcIn),
    );
  }
}
