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
    _property = newVal;

    final (newUnits, newUnitsMapSymbols) = switch (newVal) {
      PROPERTY.mass => (MASS.values, Mass().mapSymbols),
      PROPERTY.length => (LENGTH.values, Length().mapSymbols),
      PROPERTY.area => (AREA.values, Area().mapSymbols),
      PROPERTY.volume => (VOLUME.values, Volume().mapSymbols),
      PROPERTY.time => (TIME.values, Time().mapSymbols),
      PROPERTY.speed => (SPEED.values, Speed().mapSymbols),
      PROPERTY.temperature => (TEMPERATURE.values, Temperature().mapSymbols),
      PROPERTY.digitalData => (DIGITAL_DATA.values, DigitalData().mapSymbols),
      _ => throw Error()
    };

    allUnits = newUnits;
    allUnitsMapSymbols = newUnitsMapSymbols;

    _unit1 = allUnits.first;
    _unit2 = allUnits.first;

    textEditingController1.clear();
    textEditingController2.clear();

    notifyListeners();
  }

  List<Enum> allUnits = MASS.values;
  Map<dynamic, String>? allUnitsMapSymbols = Mass().mapSymbols;

  Enum _unit1 = MASS.values[0];
  Enum _unit2 = MASS.values[0];
  Enum get unit1 => _unit1;
  Enum get unit2 => _unit2;

  void onUnitType1Changed(Enum massType) {
    _unit1 = massType;

    //Value of first controller changed
    final text = textEditingController1.text
        .replaceAll(',', '')
        .replaceAll(CalculatorConstants.subtraction, '-');

    final value = double.tryParse(text);
    final convertedValue = value?.convertFromTo(_unit1, _unit2);
    _setControllerValue(
      textEditingController2,
      value: convertedValue,
    );

    notifyListeners();
  }

  void onUnitType2Changed(Enum massType) {
    _unit2 = massType;

    //Value of first controller changed
    final text = textEditingController2.text
        .replaceAll(',', '')
        .replaceAll(CalculatorConstants.subtraction, '-');

    final value = double.tryParse(text);
    final convertedValue = value?.convertFromTo(_unit2, _unit1);
    _setControllerValue(
      textEditingController1,
      value: convertedValue,
    );

    notifyListeners();
  }

  void onValueChanged(double? value) {
    if (_currentFocusNode == focusNode1) {
      log('Controller 1 value $value');
      //Value of first controller changed
      final convertedValue = value?.convertFromTo(_unit1, _unit2);
      _setControllerValue(
        textEditingController2,
        value: convertedValue,
      );
    } else if (_currentFocusNode == focusNode2) {
      log('Controller 2 value $value');
      //Value of second controller changed
      final convertedValue = value?.convertFromTo(_unit2, _unit1);
      _setControllerValue(
        textEditingController1,
        value: convertedValue,
      );
    }
  }

  void _onFocusNodeChanged() {
    if (focusNode1.hasFocus) {
      _currentController = textEditingController1;
      _currentFocusNode = focusNode1;
    } else if (focusNode2.hasFocus) {
      _currentController = textEditingController2;
      _currentFocusNode = focusNode2;
    } else {
      _currentController = null;
      _currentFocusNode = null;
    }

    notifyListeners();
  }

  void _setControllerValue(
    TextEditingController controller, {
    required double? value,
  }) {
    if (value == null) {
      controller.clear();
      return;
    }

    final formattedValue = numberFormatterMedium.format(value);
    controller.text = formattedValue.startsWith('-')
        ? CalculatorConstants.subtraction + formattedValue.substring(1)
        : formattedValue;
  }
}
