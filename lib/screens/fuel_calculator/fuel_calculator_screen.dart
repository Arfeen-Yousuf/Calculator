import 'package:calculator/app/colors.dart';
import 'package:calculator/widgets/my_drawer.dart';
import 'package:calculator/widgets/numeric_keypad.dart';
import 'package:calculator/widgets/results_card.dart';
import 'package:calculator/widgets/text_field_with_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:units_converter/units_converter.dart';

import 'fuel_calculator_view_model.dart';

class FuelCalculatorScreen extends StatelessWidget {
  static const route = '/fuel-calculator';
  static const _key = ValueKey(route);

  const FuelCalculatorScreen() : super(key: _key);

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final viewModelRead = context.read<FuelCalculatorViewModel>();

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

    const lengthUnits = [LENGTH.kilometers, LENGTH.miles];
    const distanceOptionsStrings = ['km', 'mi'];
    final distanceTextField = TextFieldWithOptions<String>(
      controller: viewModelRead.distanceTextEditingController,
      focusNode: viewModelRead.distanceFocusNode,
      title: 'Distance',
      options: distanceOptionsStrings,
      currentOption: distanceOptionsStrings[
          lengthUnits.indexOf(viewModelRead.distanceUnit)],
      onOptionSelected: (ind) =>
          viewModelRead.onDistanceUnitChanged(lengthUnits[ind]),
      hintText: '(Required)',
      labelGenerator: (p0) => 'Distance ($p0)',
    );

    final fuelEfficiencyTextField = TextFieldWithOptions<FuelEfficiency>(
      controller: viewModelRead.efficiencyTextEditingController,
      focusNode: viewModelRead.efficiencyFocusNode,
      title: 'Fuel Efficiency',
      currentOption: viewModelRead.efficiencyUnit,
      options: FuelEfficiency.values,
      onOptionSelected: (ind) =>
          viewModelRead.onFuelEfficiencyUnitChanged(FuelEfficiency.values[ind]),
      hintText: '(Required)',
      labelGenerator: (p0) => 'Fuel Efficiency ($p0)',
    );

    const priceUnits = [
      VOLUME.liters,
      VOLUME.usGallons,
      VOLUME.imperialGallons
    ];
    const priceOptionsStrings = ['\$/l', '\$/gal(US)', '\$/gal(UK)'];
    final fuelPriceTextField = TextFieldWithOptions<String>(
      controller: viewModelRead.priceTextEditingController,
      focusNode: viewModelRead.priceFocusNode,
      title: 'Fuel Price',
      options: priceOptionsStrings,
      currentOption: priceOptionsStrings[
          priceUnits.indexOf(viewModelRead.priceVolumeUnit)],
      onOptionSelected: (ind) =>
          viewModelRead.onPriceVolumeUnitChanged(priceUnits[ind]),
      hintText: '(Required)',
      labelGenerator: (p0) => 'Fuel Price ($p0)',
    );

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Fuel Calculator'),
        actions: [popupMenuButton],
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
                      distanceTextField,
                      fuelEfficiencyTextField,
                      fuelPriceTextField,
                      ResultsCard(
                        results:
                            context.watch<FuelCalculatorViewModel>().results,
                      ),
                    ],
                  ),
                ),
              ),
              if (context.watch<FuelCalculatorViewModel>().currentFocusNode !=
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
