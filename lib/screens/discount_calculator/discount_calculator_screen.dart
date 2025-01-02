import 'package:calculator/app/colors.dart';
import 'package:calculator/widgets/number_text_field.dart';
import 'package:calculator/widgets/numeric_keypad.dart';
import 'package:calculator/widgets/results_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'discount_calculator_view_model.dart';

class DiscountCalculatorScreen extends StatelessWidget {
  const DiscountCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final viewModelRead = context.read<DiscountCalculatorViewModel>();

    final popupMenuButton = PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text('Clear All'),
        ),
      ],
      onSelected: (_) => viewModelRead.clearAll(),
      color: appColors.scaffoldBackground,
      offset: const Offset(0, 50),
    );

    final taxTextField = NumberTextField(
      controller: viewModelRead.taxTextEditingController,
      focusNode: viewModelRead.taxFocusNode,
      label: 'Tax (%)',
      hintText: 'Default 0.00%',
    );
    final originalPriceTextField = NumberTextField(
      controller: viewModelRead.priceTextEditingController,
      focusNode: viewModelRead.priceFocusNode,
      label: 'Original Price',
      hintText: 'Default 0',
    );
    final discountTextField = NumberTextField(
      controller: viewModelRead.discountTextEditingController,
      focusNode: viewModelRead.discountFocusNode,
      label: 'Discount (%)',
      hintText: 'Default 0.00%',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discount Calculator'),
        actions: [
          popupMenuButton,
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 50,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 15,
                    children: [
                      taxTextField,
                      originalPriceTextField,
                      discountTextField,
                      ResultsCard(
                        results: context
                            .watch<DiscountCalculatorViewModel>()
                            .results,
                      ),
                    ],
                  ),
                ),
              ),
              if (context
                      .watch<DiscountCalculatorViewModel>()
                      .currentFocusNode !=
                  null)
                Expanded(
                  flex: 50,
                  child: NumericKeypad(
                    controller: viewModelRead.currentController!,
                    focusNode: viewModelRead.currentFocusNode,
                    onValueChanged: viewModelRead.onValueChanged,
                    allowNegativeNumbers: false,
                    percentageOnly: viewModelRead.isPercentageFocusNode,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
