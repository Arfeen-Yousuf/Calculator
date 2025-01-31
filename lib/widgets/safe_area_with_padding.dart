import 'package:flutter/material.dart';

class SafeAreaWithPadding extends StatelessWidget {
  const SafeAreaWithPadding({
    super.key,
    required this.padding,
    required this.child,
  });

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
