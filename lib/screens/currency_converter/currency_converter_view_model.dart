import 'dart:async';
import 'dart:io';

import 'package:calculator/providers/settings_provider.dart';
import 'package:calculator/services/exchange_rate_services.dart';
import 'package:calculator/utils/constants.dart';
import 'package:calculator/utils/utils.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _usd = Currency.from(
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

final _pkr = Currency.from(
  json: {
    'code': 'PKR',
    'name': 'Pakistan Rupee',
    'symbol': '₨',
    'flag': 'PKR',
    'decimal_digits': 0,
    'number': 586,
    'name_plural': 'Pakistani rupees',
    'thousands_separator': ',',
    'decimal_separator': '.',
    'space_between_amount_and_symbol': false,
    'symbol_on_left': true,
  },
);

class CurrencyConverterViewModel extends ChangeNotifier {
  BuildContext context;

  final _exchangeRates = ExchangeRateServices();
  List<String>? get currencyFilter => _exchangeRates.rates?.keys.toList();

  CurrencyConverterViewModel(this.context) {
    _currentController = textEditingController1;
    _currentFocusNode = focusNode1;
    focusNode1.requestFocus();

    focusNode1.addListener(_onFocusNodeChanged);
    focusNode2.addListener(_onFocusNodeChanged);

    fetchExchangeRates();
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    focusNode1.dispose();
    textEditingController2.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  Future<void> fetchExchangeRates() async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      await _exchangeRates.fetchExchangeRates().timeout(
        const Duration(seconds: 7, milliseconds: 500),
        onTimeout: () {
          throw TimeoutException('');
        },
      );
    } on Exception catch (e) {
      _isLoading = false;

      if (e is SocketException) {
        _errorWithDetails = (
          'No Connection',
          'Connection Error. \n'
              'Check your internet and retry.',
          Icons.wifi_off_outlined,
        );
      } else if (e is TimeoutException) {
        _errorWithDetails = (
          'Request Timed Out',
          'The request took too long to respond. \n'
              'Check your internet and retry.',
          Icons.timer_off_outlined,
        );
      } else {
        _errorWithDetails = (
          'Oops!',
          'Something unexpected occured.',
          Icons.error_outline_outlined,
        );
      }

      notifyListeners();
      return;
    }

    _computeConversionFormula();
    _isLoading = false;
    _errorWithDetails = null;
    notifyListeners();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  (String, String, IconData)? _errorWithDetails;
  (String, String, IconData)? get errorWithDetails => _errorWithDetails;

  TextEditingController? _currentController;
  TextEditingController? get currentController => _currentController;
  FocusNode? _currentFocusNode;
  FocusNode? get currentFocusNode => _currentFocusNode;

  final textEditingController1 = TextEditingController();
  final focusNode1 = FocusNode();

  final textEditingController2 = TextEditingController();
  final focusNode2 = FocusNode();

  Currency _currency1 = _usd;
  Currency _currency2 = _pkr;

  Currency get currency1 => _currency1;
  Currency get currency2 => _currency2;

  DateTime? get updatedDate => _exchangeRates.dateTime;

  String? _conversionFormula = '';
  String? get conversionFormula => _conversionFormula;
  void _computeConversionFormula() {
    double conversionFactor = _exchangeRates.convertCurrency(
      amount: 1,
      from: _currency1,
      to: _currency2,
    )!;
    conversionFactor = (conversionFactor * 10000).round() / 10000;

    _conversionFormula =
        '1 ${currency1.code} ≈ $conversionFactor ${currency2.code}';
  }

  void onCurrency1Changed(Currency currency) {
    _currency1 = currency;

    //Value of second controller changed
    final text = textEditingController2.text
        .replaceAll(',', '')
        .replaceAll(CalculatorConstants.subtraction, '-');

    final value = double.tryParse(text);
    final convertedValue = _exchangeRates.convertCurrency(
      amount: value,
      from: _currency2,
      to: _currency1,
    );

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
    final convertedValue = _exchangeRates.convertCurrency(
      amount: value,
      from: _currency1,
      to: _currency2,
    );

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
      final convertedValue = _exchangeRates.convertCurrency(
        amount: value,
        from: _currency1,
        to: _currency2,
      );
      _setControllerValue(
        textEditingController2,
        value: convertedValue,
      );
    } else if (_currentFocusNode == focusNode2) {
      //Value of second controller changed
      final convertedValue = _exchangeRates.convertCurrency(
        amount: value,
        from: _currency2,
        to: _currency1,
      );
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
