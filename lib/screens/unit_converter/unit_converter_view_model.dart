import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:units_converter/units_converter.dart';

class UnitConverterViewModel extends ChangeNotifier {
  UnitConverterViewModel() {
    _currentController = textEditingController1;
    _currentFocusNode = focusNode1;

    focusNode1.addListener(() {
      if (focusNode1.hasFocus) {
        log('Focus 1');

        _currentController = textEditingController1;
        _currentFocusNode = focusNode1;
        notifyListeners();
      }
    });

    focusNode2.addListener(() {
      if (focusNode2.hasFocus) {
        log('Focus 2');
        _currentController = textEditingController2;
        _currentFocusNode = focusNode2;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    focusNode1.dispose();
    textEditingController2.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  late TextEditingController _currentController;
  TextEditingController get currentController => _currentController;
  late FocusNode _currentFocusNode;
  FocusNode get currentFocusNode => _currentFocusNode;

  final textEditingController1 = TextEditingController();
  final focusNode1 = FocusNode();

  final textEditingController2 = TextEditingController();
  final focusNode2 = FocusNode();

  //Length, mass, volume, time, data etc
  PROPERTY _property = PROPERTY.mass;
  PROPERTY get property => _property;
  set property(PROPERTY newVal) {
    _property = newVal;
    notifyListeners();
  }

  MASS massUnit1 = MASS.micrograms;
  MASS massUnit2 = MASS.milligrams;
}
