import 'package:calculator/providers/settings_provider.dart';
import 'package:calculator/utils/ui_helper.dart';
import 'package:flutter/material.dart';

import 'package:calculator/widgets/my_switch.dart';
import 'package:calculator/widgets/settings_list_tile.dart';
import 'package:calculator/widgets/safe_area_with_padding.dart';
import 'package:provider/provider.dart';

class CalculatorSettingsScreen extends StatelessWidget {
  const CalculatorSettingsScreen({super.key});

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
                onTap: () => _onKeepLastRecordChanged(
                  context,
                  !context.watch<SettingsProvider>().keepLastRecord,
                ),
                trailing: MySwitch(
                  value: context.watch<SettingsProvider>().keepLastRecord,
                  onChanged: (newValue) =>
                      _onKeepLastRecordChanged(context, newValue),
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
                      '${context.watch<SettingsProvider>().decimalPlaces}',
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
    final settingsProvider = context.read<SettingsProvider>();

    final int? pickedDecimal = await showValuePicker(
      context,
      title: 'Decimal Place',
      values: List.generate(11, (index) => index),
      initialIndex: settingsProvider.decimalPlaces,
    );

    if (pickedDecimal != null && context.mounted) {
      await settingsProvider.updateDecimalPlaces(pickedDecimal);
    }
  }

  void _onKeepLastRecordChanged(
    BuildContext context,
    bool newValue,
  ) async {
    await context.read<SettingsProvider>().updateKeepLastRecord(newValue);
  }
}
