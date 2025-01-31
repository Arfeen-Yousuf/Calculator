import 'package:calculator/utils/ui_helper.dart';
import 'package:flutter/material.dart';

import 'package:calculator/widgets/settings_list_tile.dart';
import 'package:calculator/widgets/safe_area_with_padding.dart';

enum DarkMode {
  auto,
  light,
  dark;

  @override
  String toString() {
    return switch (this) {
      auto => 'Auto',
      light => 'Light',
      dark => 'Dark',
    };
  }
}

class DisplaySettingsScreen extends StatefulWidget {
  const DisplaySettingsScreen({super.key});

  @override
  State<DisplaySettingsScreen> createState() => _DisplaySettingsScreenState();
}

class _DisplaySettingsScreenState extends State<DisplaySettingsScreen> {
  DarkMode darkMode = DarkMode.auto;

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
                      '$darkMode',
                      style: TextTheme.of(context).bodyLarge,
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
              divider,
              SettingsListTile(
                title: 'Theme',
                onTap: () {},
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Orange',
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
    final DarkMode? pickedDarkMode = await showValuePicker(
      context,
      title: 'Dark Mode',
      values: DarkMode.values,
      initialIndex: DarkMode.values.indexOf(darkMode),
    );

    if (pickedDarkMode != null) {
      setState(() {
        darkMode = pickedDarkMode;
      });
    }
  }
}
