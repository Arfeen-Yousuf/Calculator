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
  void setProperty(PROPERTY newVal) {
    log('Property set $newVal');

    _property = newVal;
    final List<dynamic> values;
    switch (newVal) {
      case PROPERTY.mass:
        values = MASS.values;
      case PROPERTY.length:
        values = LENGTH.values;

      case PROPERTY.area:
        values = AREA.values;
      case PROPERTY.volume:
        values = VOLUME.values;
      case PROPERTY.time:
        values = TIME.values;
      case PROPERTY.speed:
        values = SPEED.values;
      case PROPERTY.temperature:
        values = TEMPERATURE.values;
      case PROPERTY.digitalData:
        values = DIGITAL_DATA.values;
      default:
        throw Error();
    }

    //Mass().mapSymbols;

    allUnits = values;
    //.map((unit) => camelCaseToNormal(unit.toString().split('.')[1]))
    //.toList();
    _unit1 = values[0];
    _unit2 = values[0];

    log('Now units are $_unit1 $_unit2');

    textEditingController1.clear();
    textEditingController2.clear();
    notifyListeners();
  }

  List<dynamic> allUnits = MASS.values;
  //.map((unit) => camelCaseToNormal(unit.toString().split('.')[1]))
  //.toList();

  dynamic _unit1 = MASS.values[0];
  dynamic _unit2 = MASS.values[0];
  get unit1 => _unit1;
  get unit2 => _unit2;

  void onMassType1Changed(dynamic massType) {
    _unit1 = massType;
    log('Convertingv 1 $_unit1 ${textEditingController1.text} $_unit2 ${textEditingController2.text}');

    //Value of first controller changed
    final text = textEditingController1.text
        .replaceAll(',', '')
        .replaceAll(CalculatorConstants.subtraction, '');
    final value = double.tryParse(text);

    if (value == null) {
      textEditingController2.clear();
      return;
    }

    final convertedValue = value.convertFromTo(_unit1, _unit2);
    textEditingController2.text =
        (convertedValue == null) ? '' : numberFormatter.format(convertedValue);

    notifyListeners();
  }

  void onMassType2Changed(dynamic massType) {
    _unit2 = massType;
    log('Converting 2 $_unit1 ${textEditingController1.text} $_unit2 ${textEditingController2.text}');

    //Value of first controller changed
    final text = textEditingController2.text
        .replaceAll(',', '')
        .replaceAll(CalculatorConstants.subtraction, '');
    final value = double.tryParse(text);

    if (value == null) {
      textEditingController1.clear();
      return;
    }

    final convertedValue = value.convertFromTo(_unit2, _unit1);
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

      final convertedValue = value.convertFromTo(_unit1, _unit2);
      textEditingController2.text = (convertedValue == null)
          ? ''
          : numberFormatter.format(convertedValue);
    } else if (_currentFocusNode == focusNode2) {
      //Value of second controller changed
      if (value == null) {
        textEditingController1.clear();
        return;
      }

      final convertedValue = value.convertFromTo(_unit2, _unit1);
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
