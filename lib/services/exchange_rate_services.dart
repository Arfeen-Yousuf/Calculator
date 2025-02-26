import 'dart:async';
import 'dart:convert';

import 'package:currency_picker/currency_picker.dart';
import 'package:http/http.dart' as http;

class ExchangeRateServices {
  static const _apiKey = '5c9807b5875a4053b34dfa060ab0384a';
  static const _apiUrl =
      'https://openexchangerates.org/api/latest.json?app_id=$_apiKey';

  DateTime? _dateTime;
  DateTime? get dateTime => _dateTime;

  Map<String, double>? _rates;
  Map<String, double>? get rates => _rates;

  Future<void> fetchExchangeRates() async {
    final response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load currency data');
    }

    final data = jsonDecode(response.body);

    int timestamp = data['timestamp'];
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    Map<String, double> rates = (data['rates'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(
        key,
        value.toDouble(),
      ),
    );

    _dateTime = dateTime;
    _rates = rates;
  }

  double? convertCurrency({
    required double? amount,
    required Currency from,
    required Currency to,
  }) {
    if (amount == null) return null;
    if (_rates == null) {
      throw Exception('Rates not initialized');
    }

    final rates = _rates!;
    if (!rates.containsKey(from.code) || !rates.containsKey(to.code)) {
      throw ArgumentError('Invalid currency code');
    }

    double amountInUSD = amount / rates[from.code]!;
    double convertedAmount = amountInUSD * rates[to.code]!;

    return convertedAmount;
  }
}
