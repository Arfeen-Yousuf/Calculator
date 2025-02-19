import 'package:calculator/providers/settings_provider.dart';
import 'package:calculator/utils/screen_data.dart';
import 'package:calculator/utils/ui_helper.dart';
import 'package:flutter/material.dart';

import 'package:calculator/widgets/settings_list_tile.dart';
import 'package:calculator/widgets/safe_area_with_padding.dart';
import 'package:provider/provider.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = <ScreenData>[
      ScreenData.home,
      ...ScreenData.calculatorScreens
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('General Settings'),
      ),
      body: SafeAreaWithPadding(
        padding: const EdgeInsets.all(8),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingsListTile(
                title: 'Startup Calculator',
                subtitle:
                    screens[context.watch<SettingsProvider>().startUpCalculator]
                        .title,
                onTap: () => _onStartUpCalculatorTap(context),
                trailing: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onStartUpCalculatorTap(BuildContext context) async {
    final settingsProvider = context.read<SettingsProvider>();

    final pickedModeIndex = await showValuePicker<String>(
      context,
      title: 'Startup Calculator',
      values: [
        ScreenData.home.title,
        ...ScreenData.calculatorScreens.map(
          (screen) => screen.title,
        )
      ],
      initialIndex: settingsProvider.startUpCalculator,
    );

    if (pickedModeIndex != null && context.mounted) {
      await context
          .read<SettingsProvider>()
          .updateStartUpCalculator(pickedModeIndex);
    }
  }
}
