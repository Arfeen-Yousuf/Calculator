import 'package:calculator/app/colors.dart';
import 'package:calculator/utils/ui_helper.dart';
import 'package:calculator/utils/utils.dart';
import 'package:calculator/widgets/my_drawer.dart';
import 'package:calculator/widgets/numeric_keypad.dart';
import 'package:calculator/widgets/svg_icon.dart';
import 'package:calculator/widgets/text_field_with_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:units_converter/units_converter.dart';

import 'unit_converter_view_model.dart';

class UnitConverterScreen extends StatelessWidget {
  static const route = '/unit-converter';
  static const _key = ValueKey(route);

  const UnitConverterScreen() : super(key: _key);

  static const List<PROPERTY> properties = [
    PROPERTY.length,
    PROPERTY.mass,
    PROPERTY.area,
    PROPERTY.volume,
    PROPERTY.time,
    PROPERTY.speed,
    PROPERTY.temperature,
    PROPERTY.digitalData,
  ];
  static const Map<PROPERTY, SvgIconData> propertiesIcons = {
    PROPERTY.length: SvgIconData.length,
    PROPERTY.mass: SvgIconData.mass,
    PROPERTY.area: SvgIconData.area,
    PROPERTY.volume: SvgIconData.volume,
    PROPERTY.time: SvgIconData.time,
    PROPERTY.speed: SvgIconData.speed,
    PROPERTY.temperature: SvgIconData.temperature,
    PROPERTY.digitalData: SvgIconData.data,
  };

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final appColors = Theme.of(context).extension<AppColors>()!;

    final viewModelRead = context.read<UnitConverterViewModel>();

    final selectQuantityTypeButton = FilledButton(
      onPressed: () => _showPropertyPicker(context),
      style: FilledButton.styleFrom(
        backgroundColor: appColors.optionsBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgIcon(
            propertiesIcons[viewModelRead.property]!,
            size: 20,
            color: appColors.primary,
          ),
          const SizedBox(width: 10),
          Text(
            enumToNormal(viewModelRead.property),
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
                    selectQuantityTypeButton,
                    TextFieldWithOptions(
                      controller: viewModelRead.textEditingController1,
                      focusNode: viewModelRead.focusNode1,
                      title:
                          _getEnumWithSymbol(context, viewModelRead.property),
                      currentOption:
                          _getEnumWithSymbol(context, viewModelRead.unit1),
                      options: viewModelRead.allUnits
                          .map((enu) => _getEnumWithSymbol(context, enu))
                          .toList(),
                      onOptionSelected: (ind) =>
                          _onOption1Changed(context, index: ind),
                    ),
                    TextFieldWithOptions(
                      controller: viewModelRead.textEditingController2,
                      focusNode: viewModelRead.focusNode2,
                      title:
                          _getEnumWithSymbol(context, viewModelRead.property),
                      currentOption:
                          _getEnumWithSymbol(context, viewModelRead.unit2),
                      options: viewModelRead.allUnits
                          .map((enu) => _getEnumWithSymbol(context, enu))
                          .toList(),
                      onOptionSelected: (ind) =>
                          _onOption2Changed(context, index: ind),
                    ),
                    if (context
                            .watch<UnitConverterViewModel>()
                            .conversionFormula !=
                        null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${viewModelRead.conversionFormula!}\n(Rounded to 7 decimals)',
                          textAlign: TextAlign.end,
                        ),
                      ),
                  ],
                ),
              ),
              if (context.watch<UnitConverterViewModel>().currentFocusNode !=
                  null)
                Expanded(
                  flex: 50,
                  child: NumericKeypad(
                    controller: viewModelRead.currentController!,
                    focusNode: viewModelRead.currentFocusNode,
                    onValueChanged: viewModelRead.onValueChanged,
                    allowNegativeNumbers:
                        (viewModelRead.property == PROPERTY.temperature),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onOption1Changed(
    BuildContext context, {
    required int index,
  }) {
    final viewModelRead = context.read<UnitConverterViewModel>();
    viewModelRead.onUnitType1Changed(viewModelRead.allUnits[index]);
  }

  void _onOption2Changed(
    BuildContext context, {
    required int index,
  }) {
    final viewModelRead = context.read<UnitConverterViewModel>();
    viewModelRead.onUnitType2Changed(viewModelRead.allUnits[index]);
  }

  void _showPropertyPicker(BuildContext context) async {
    final viewModelRead = context.read<UnitConverterViewModel>();
    final appColors = Theme.of(context).extension<AppColors>()!;

    final Map<String, Widget> propertiesWidgets = propertiesIcons.map(
      (prop, asset) => MapEntry(
        enumToNormal(prop),
        SvgIcon(
          asset,
          size: 28,
          color: (viewModelRead.property == prop) ? appColors.primary : null,
        ),
      ),
    );

    await showOptionsBottomSheet(
      context,
      title: 'Select Unit',
      leading: propertiesWidgets,
      options: enumListToNormal(properties),
      currentOption: enumToNormal(viewModelRead.property),
      onOptionSelected: (index) => viewModelRead.setProperty(properties[index]),
    );
  }

  String _getEnumWithSymbol(BuildContext context, Enum enu) {
    final unitSymbol =
        context.read<UnitConverterViewModel>().allUnitsMapSymbols?[enu];
    return enumToNormal(enu) + ((unitSymbol != null) ? ' ($unitSymbol)' : '');
  }
}
