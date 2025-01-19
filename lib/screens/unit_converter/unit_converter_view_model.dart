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

    _computeConversionFormula();
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
  PROPERTY _property = PROPERTY.length;
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
    _unit2 = allUnits[1];
    _computeConversionFormula();

    textEditingController1.clear();
    textEditingController2.clear();

    notifyListeners();
  }

  List<Enum> allUnits = LENGTH.values;
  Map<dynamic, String>? allUnitsMapSymbols = Length().mapSymbols;

  Enum _unit1 = LENGTH.values[0];
  Enum _unit2 = LENGTH.values[1];
  Enum get unit1 => _unit1;
  Enum get unit2 => _unit2;

  String? _conversionFormula;
  String? get conversionFormula => _conversionFormula;
  void _computeConversionFormula() {
    final unit1Str = allUnitsMapSymbols?[_unit1] ?? enumToNormal(_unit1);
    final unit2Str = allUnitsMapSymbols?[_unit2] ?? enumToNormal(_unit2);
    final conversionFactor = 1.convertFromTo(_unit1, _unit2)!;

    _conversionFormula = (_property == PROPERTY.temperature)
        ? null
        : '1 $unit1Str = ${roundToDecimalPlaces(conversionFactor, 7)} $unit2Str';
  }

  void onUnitType1Changed(Enum unitType) {
    _unit1 = unitType;

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
    _computeConversionFormula();

    notifyListeners();
  }

  void onUnitType2Changed(Enum unitType) {
    _unit2 = unitType;

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
    _computeConversionFormula();

    notifyListeners();
  }

  void onValueChanged(double? value) {
    if (_currentFocusNode == focusNode1) {
      //Value of first controller changed
      final convertedValue = value?.convertFromTo(_unit1, _unit2);
      _setControllerValue(
        textEditingController2,
        value: convertedValue,
      );
    } else if (_currentFocusNode == focusNode2) {
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
