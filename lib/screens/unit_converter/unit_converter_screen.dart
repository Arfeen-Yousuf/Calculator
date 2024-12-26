import 'package:calculator/app/colors.dart';
import 'package:calculator/utils/utils.dart';
import 'package:calculator/widgets/numeric_keypad.dart';
import 'package:calculator/widgets/text_field_with_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:units_converter/units_converter.dart';

import 'unit_converter_view_model.dart';

class UnitConverterScreen extends StatelessWidget {
  UnitConverterScreen({super.key});

  final List<String> massOptions = Mass()
          .mapSymbols
          ?.keys
          .map((key) => camelCaseToNormal(key.toString().split('.')[1]))
          .toList() ??
      [];

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final appColors = Theme.of(context).extension<AppColors>()!;

    final viewModelRead = context.read<UnitConverterViewModel>();
    final viewModel = context.watch<UnitConverterViewModel>();

    final selectQuantityTypeButton = FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        //backgroundColor: isLightTheme ? Colors.grey[300]! : Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isLightTheme ? Colors.black : Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.ring_volume_outlined,
            color: appColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Speed',
            style: TextTheme.of(context).labelLarge?.copyWith(
                  color: appColors.primaryText,
                  fontSize: 20,
                ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_drop_down,
            color: isLightTheme ? Colors.black : Colors.white,
            size: 30,
          ),
        ],
      ),
    );

    return Scaffold(
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
                    selectQuantityTypeButton,
                    TextFieldWithOptions(
                      controller: viewModelRead.textEditingController1,
                      focusNode: viewModelRead.focusNode1,
                      title: 'Mass',
                      options: massOptions,
                      onOptionSelected: (ind) =>
                          onOption1Changed(context, index: ind),
                    ),
                    TextFieldWithOptions(
                      controller: viewModelRead.textEditingController2,
                      focusNode: viewModelRead.focusNode2,
                      title: 'Mass',
                      options: massOptions,
                      onOptionSelected: (ind) =>
                          onOption2Changed(context, index: ind),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 50,
                child: NumericKeypad(
                  controller: viewModel.currentController,
                ),
              ),
              //Text(viewModel.currentController.text)
            ],
          ),
        ),
      ),
    );
  }

  void onOption1Changed(
    BuildContext context, {
    required int index,
  }) {
    final viewModelRead = context.read<UnitConverterViewModel>();
    viewModelRead.massUnit1 = MASS.values[index];
  }

  void onOption2Changed(
    BuildContext context, {
    required int index,
  }) {}
}
