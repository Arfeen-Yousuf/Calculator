import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const _assetsBasePath = 'assets/svg_icons/';

enum SvgIconData {
  length('length'),
  mass('mass'),
  area('area'),
  volume('volume'),
  time('time'),
  speed('speed'),
  temperature('temperature'),
  data('data');

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
    final svgColor = color ?? IconTheme.of(context).color;

    return SvgPicture.asset(
      iconData.path,
      height: size,
      width: size,
      colorFilter: ColorFilter.mode(svgColor!, BlendMode.srcIn),
    );
  }
}
