import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const _assetsBasePath = 'assets/svg_icons/';

class SvgIconData {
  const SvgIconData._(String name) : path = '$_assetsBasePath$name.svg';
  final String path;

  static const calculator = SvgIconData._('calculator');
  static const calculate = SvgIconData._('calculate');
  static const calendar = SvgIconData._('calendar');
  static const currency = SvgIconData._('currency');
  static const fuel = SvgIconData._('fuel');
  static const home = SvgIconData._('home');
  static const length = SvgIconData._('length');
  static const mass = SvgIconData._('mass');
  static const area = SvgIconData._('area');
  static const volume = SvgIconData._('volume');
  static const time = SvgIconData._('time');
  static const speed = SvgIconData._('speed');
  static const temperature = SvgIconData._('temperature');
  static const data = SvgIconData._('data');
  static const ruler = SvgIconData._('ruler');
  static const discount = SvgIconData._('discount');
  static const settings = SvgIconData._('settings');
  static const display = SvgIconData._('display');
  static const theme = SvgIconData._('theme');
  static const star = SvgIconData._('star');
  static const share = SvgIconData._('share');
  static const security = SvgIconData._('security');
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
