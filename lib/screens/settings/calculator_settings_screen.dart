import 'package:calculator/utils/ui_helper.dart';
import 'package:flutter/material.dart';

import 'package:calculator/widgets/my_switch.dart';
import 'package:calculator/widgets/settings_list_tile.dart';
import 'package:calculator/widgets/safe_area_with_padding.dart';

class CalculatorSettingsScreen extends StatefulWidget {
  const CalculatorSettingsScreen({super.key});

  @override
  State<CalculatorSettingsScreen> createState() =>
      _CalculatorSettingsScreenState();
}

class _CalculatorSettingsScreenState extends State<CalculatorSettingsScreen> {
  int decimalPlaces = 0;

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      height: 2,
      indent: 18,
      endIndent: 18,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator Settings'),
      ),
      body: SafeAreaWithPadding(
        padding: const EdgeInsets.all(8),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingsListTile(
                title: 'Keep the Last Record',
                onTap: () {},
                trailing: MySwitch(
                  onChanged: (value) {},
                ),
              ),
              divider,
              SettingsListTile(
                title: 'Decimal Place',
                onTap: () => _onDecimalPlaceTap(context),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$decimalPlaces',
                      style: TextTheme.of(context).bodyLarge,
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDecimalPlaceTap(BuildContext context) async {
    final int? pickedDecimal = await showValuePicker(
      context,
      title: 'Decimal Place',
      values: List.generate(11, (index) => index),
      initialIndex: decimalPlaces,
    );

    if (pickedDecimal != null) {
      setState(() {
        decimalPlaces = pickedDecimal;
      });
    }
  }
}
