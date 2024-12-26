import 'dart:developer';

import 'package:calculator/utils/constants.dart';
import 'package:calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:units_converter/units_converter.dart';

class UnitConverterViewModel extends ChangeNotifier {
  UnitConverterViewModel() {
    _currentController = textEditingController1;
    _currentFocusNode = focusNode1;
    focusNode1.requestFocus();

    focusNode1.addListener(_onFocusNodeChanged);
    focusNode2.addListener(_onFocusNodeChanged);
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    focusNode1.dispose();
    textEditingController2.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  TextEditingController? _currentController;
  TextEditingController? get currentController => _currentController;
  FocusNode? _currentFocusNode;
  FocusNode? get currentFocusNode => _currentFocusNode;

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

  MASS _massUnit1 = MASS.micrograms;
  MASS _massUnit2 = MASS.milligrams;

  void onMassType1Changed(MASS massType) {
    _massUnit1 = massType;
    log('Convertingv 1 $_massUnit1 ${textEditingController1.text} $_massUnit2 ${textEditingController2.text}');

    //Value of first controller changed
    final text = textEditingController1.text
        .replaceAll(',', '')
        .replaceAll(CalculatorConstants.subtraction, '');
    final value = double.tryParse(text);

    if (value == null) {
      textEditingController2.clear();
      return;
    }

    final convertedValue = value.convertFromTo(_massUnit1, _massUnit2);
    textEditingController2.text =
        (convertedValue == null) ? '' : numberFormatter.format(convertedValue);

    notifyListeners();
  }

  void onMassType2Changed(MASS massType) {
    _massUnit2 = massType;
    log('Converting 2 $_massUnit1 ${textEditingController1.text} $_massUnit2 ${textEditingController2.text}');

    //Value of first controller changed
    final text = textEditingController2.text
        .replaceAll(',', '')
        .replaceAll(CalculatorConstants.subtraction, '');
    final value = double.tryParse(text);

    if (value == null) {
      textEditingController1.clear();
      return;
    }

    final convertedValue = value.convertFromTo(_massUnit2, _massUnit1);
    textEditingController1.text =
        (convertedValue == null) ? '' : numberFormatter.format(convertedValue);

    //notifyListeners();
  }

  void onValueChanged(double? value) {
    if (_currentFocusNode == focusNode1) {
      //Value of first controller changed
      if (value == null) {
        textEditingController2.clear();
        return;
      }

      final convertedValue = value.convertFromTo(_massUnit1, _massUnit2);
      textEditingController2.text = (convertedValue == null)
          ? ''
          : numberFormatter.format(convertedValue);
    } else if (_currentFocusNode == focusNode2) {
      //Value of second controller changed
      if (value == null) {
        textEditingController1.clear();
        return;
      }

      final convertedValue = value.convertFromTo(_massUnit2, _massUnit1);
      textEditingController1.text = (convertedValue == null)
          ? ''
          : numberFormatter.format(convertedValue);
    }
  }

  void _onFocusNodeChanged() {
    if (focusNode1.hasFocus) {
      log('Focus 1');
      _currentController = textEditingController1;
      _currentFocusNode = focusNode1;
    } else if (focusNode2.hasFocus) {
      log('Focus 2');
      _currentController = textEditingController2;
      _currentFocusNode = focusNode2;
    } else {
      _currentController = null;
      _currentFocusNode = null;
    }

    notifyListeners();
  }
}
