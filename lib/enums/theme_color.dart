import 'package:flutter/material.dart';

enum ThemeColor {
  green(Colors.green, 'Green'),
  blue(Colors.blue, 'Blue'),
  red(Colors.red, 'Red'),
  orange(Colors.orange, 'Orange'),
  purple(Colors.purple, 'Purple'),
  yellow(Colors.yellow, 'Yellow'),
  pink(Colors.pink, 'Pink'),
  brown(Colors.brown, 'Brown'),
  cyan(Colors.cyan, 'Cyan'),
  teal(Colors.teal, 'Teal');

  final Color color;
  final String label;

  const ThemeColor(this.color, this.label);

  @override
  String toString() => label;
}
