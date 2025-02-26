import 'package:calculator/widgets/currency_text_field.dart';
import 'package:calculator/widgets/my_drawer.dart';
import 'package:calculator/widgets/numeric_keypad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'currency_converter_view_model.dart';

class CurrencyConverterScreen extends StatelessWidget {
  static const route = '/currency-converter';
  static const _key = ValueKey(route);

  const CurrencyConverterScreen() : super(key: _key);

  @override
  Widget build(BuildContext context) {
    final viewModelRead = context.read<CurrencyConverterViewModel>();

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Unit Converter'),
      ),
      body: SafeArea(
        child: Padding(
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
                      onCurrencySelected: viewModelRead.onCurrency1Changed,
                    ),
                    CurrencyTextField(
                      controller: viewModelRead.textEditingController2,
                      focusNode: viewModelRead.focusNode2,
                      currency: viewModelRead.currency2,
                      onCurrencySelected: viewModelRead.onCurrency2Changed,
                    ),
                    if (context
                            .watch<CurrencyConverterViewModel>()
                            .conversionFormula !=
                        null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          viewModelRead.conversionFormula!,
                          textAlign: TextAlign.end,
                        ),
                      ),
                  ],
                ),
              ),
              if (context
                      .watch<CurrencyConverterViewModel>()
                      .currentFocusNode !=
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
        ),
      ),
    );
  }
}
