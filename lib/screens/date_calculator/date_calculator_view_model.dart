import 'package:flutter/material.dart';

class DateCalculatorViewModel extends ChangeNotifier {
  final durationController = TextEditingController();
  final durationFocusNode = FocusNode();

  int _duration = 0;
}
