import 'package:calculator/providers/settings_provider.dart';
import 'package:calculator/utils/constants.dart';
import 'package:calculator/utils/utils.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Currency _usd = Currency.from(
  json: {
    'code': 'USD',
    'name': 'United States Dollar',
    'symbol': '\$',
    'flag': 'USD',
    'decimal_digits': 2,
    'number': 840,
    'name_plural': 'US dollars',
    'thousands_separator': ',',
    'decimal_separator': '.',
    'space_between_amount_and_symbol': false,
    'symbol_on_left': true,
  },
);

class CurrencyConverterViewModel extends ChangeNotifier {
  BuildContext context;

  CurrencyConverterViewModel(this.context) {
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

  Currency _currency1 = _usd;
  Currency _currency2 = _usd;

  Currency get currency1 => _currency1;
  Currency get currency2 => _currency2;

  String? _conversionFormula;
  String? get conversionFormula => _conversionFormula;
  void _computeConversionFormula() {
    //TODO: Implement
  }

  void onCurrency1Changed(Currency currency) {
    _currency1 = currency;

    //Value of second controller changed
    final text = textEditingController2.text
        .replaceAll(',', '')
        .replaceAll(CalculatorConstants.subtraction, '-');

    final value = double.tryParse(text);
    final convertedValue = value;
    _setControllerValue(
      textEditingController1,
      value: convertedValue,
    );
    _computeConversionFormula();

    notifyListeners();
  }

  void onCurrency2Changed(Currency currency) {
    _currency2 = currency;

    //Value of first controller changed
    final text = textEditingController1.text
        .replaceAll(',', '')
        .replaceAll(CalculatorConstants.subtraction, '-');

    final value = double.tryParse(text);
    final convertedValue = value;
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
      //TODO: Compute the converted value
      final convertedValue = value;
      _setControllerValue(
        textEditingController2,
        value: convertedValue,
      );
    } else if (_currentFocusNode == focusNode2) {
      //Value of second controller changed
      //TODO: Compute the converted value
      final convertedValue = value;
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

    final formattedValue = formatNumber(
      value,
      decimalPlaces: context.read<SettingsProvider>().decimalPlaces,
    );

    controller.text = formattedValue.startsWith('-')
        ? CalculatorConstants.subtraction + formattedValue.substring(1)
        : formattedValue;
  }
}
