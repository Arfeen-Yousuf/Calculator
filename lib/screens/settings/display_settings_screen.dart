import 'package:calculator/enums/theme_color.dart';
import 'package:calculator/providers/settings_provider.dart';
import 'package:calculator/utils/ui_helper.dart';
import 'package:flutter/material.dart';

import 'package:calculator/widgets/settings_list_tile.dart';
import 'package:calculator/widgets/safe_area_with_padding.dart';
import 'package:provider/provider.dart';

final _themeLabels = ['Auto', 'Off', 'On']; //Order matters

class DisplaySettingsScreen extends StatelessWidget {
  const DisplaySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      height: 2,
      indent: 18,
      endIndent: 18,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Settings'),
      ),
      body: SafeAreaWithPadding(
        padding: const EdgeInsets.all(8),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingsListTile(
                title: 'Dark Mode',
                onTap: () => _onDarkModeTap(context),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _themeLabels[
                          context.watch<SettingsProvider>().themeMode.index],
                      style: TextTheme.of(context).bodyLarge,
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
              divider,
              SettingsListTile(
                title: 'Color',
                onTap: () => _onThemeColorTap(context),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${context.watch<SettingsProvider>().themeColor}',
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

  void _onDarkModeTap(BuildContext context) async {
    final themeProvider = context.read<SettingsProvider>();

    const values = ThemeMode.values;
    final pickedModeIndex = await showValuePicker<String>(
      context,
      title: 'Dark Mode',
      values: _themeLabels,
      initialIndex: themeProvider.themeMode.index,
    );

    if (pickedModeIndex != null && context.mounted) {
      await context
          .read<SettingsProvider>()
          .updateThemeMode(values[pickedModeIndex]);
    }
  }

  void _onThemeColorTap(BuildContext context) async {
    final themeProvider = context.read<SettingsProvider>();

    const values = ThemeColor.values;
    final pickedColorIndex = await showValuePicker<ThemeColor>(
      context,
      title: 'Color',
      values: values,
      initialIndex: themeProvider.themeColor.index,
    );

    if (pickedColorIndex != null && context.mounted) {
      await context
          .read<SettingsProvider>()
          .updateThemeColor(values[pickedColorIndex]);
    }
  }
}
