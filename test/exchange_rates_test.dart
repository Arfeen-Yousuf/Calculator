// ignore_for_file: avoid_print

import 'package:calculator/services/exchange_rate_services.dart';

void main() async {
  final services = ExchangeRateServices();
  await services.fetchExchangeRates();
  print(services.dateTime);
  print(services.rates);
}
