import 'package:calculator/widgets/currency_text_field.dart';
import 'package:calculator/widgets/my_drawer.dart';
import 'package:calculator/widgets/numeric_keypad.dart';
import 'package:calculator/widgets/primary_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'currency_converter_view_model.dart';

class CurrencyConverterScreen extends StatelessWidget {
  static const route = '/currency-converter';
  static const _key = ValueKey(route);

  const CurrencyConverterScreen() : super(key: _key);

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    final viewModelRead = context.read<CurrencyConverterViewModel>();

    final Widget body;
    if (context.watch<CurrencyConverterViewModel>().isLoading) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (context.watch<CurrencyConverterViewModel>().errorWithDetails !=
        null) {
      final error =
          context.read<CurrencyConverterViewModel>().errorWithDetails!;
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15,
          children: [
            Icon(error.$3, size: 90),
            Text(
              error.$1,
              style: TextTheme.of(context).labelLarge?.copyWith(
                    fontSize: 20,
                  ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                error.$2,
                style: TextTheme.of(context).labelSmall?.copyWith(
                      fontSize: 15,
                      color: Colors.grey[400],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            PrimaryTextFilledButton(
              text: 'Try Again',
              onPressed: () async => await viewModelRead.fetchExchangeRates(),
            ),
          ],
        ),
      );
    } else {
      DateFormat formatter = DateFormat('HH:mm, MMM d, yyyy');

      body = Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 10,
          children: [
            Expanded(
              flex: 50,
              child: ListView(
                children: [
                  CurrencyTextField(
                    controller: viewModelRead.textEditingController1,
                    focusNode: viewModelRead.focusNode1,
                    currency: viewModelRead.currency1,
                    currencyFilter: viewModelRead.currencyFilter,
                    onCurrencySelected: viewModelRead.onCurrency1Changed,
                  ),
                  CurrencyTextField(
                    controller: viewModelRead.textEditingController2,
                    focusNode: viewModelRead.focusNode2,
                    currency: viewModelRead.currency2,
                    currencyFilter: viewModelRead.currencyFilter,
                    onCurrencySelected: viewModelRead.onCurrency2Changed,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          viewModelRead.conversionFormula!,
                          style: TextTheme.of(context)
                              .labelLarge
                              ?.copyWith(fontSize: 17),
                        ),
                        Text(
                          'Rates of ${formatter.format(viewModelRead.updatedDate!)}',
                          style: TextStyle(
                            color: textTheme.labelSmall?.color?.withAlpha(170),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (context.watch<CurrencyConverterViewModel>().currentFocusNode !=
                null)
              Expanded(
                flex: 50,
                child: NumericKeypad(
                  controller: viewModelRead.currentController!,
                  focusNode: viewModelRead.currentFocusNode,
                  onValueChanged: viewModelRead.onValueChanged,
                  allowNegativeNumbers: false,
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: SafeArea(child: body),
    );
  }
}
