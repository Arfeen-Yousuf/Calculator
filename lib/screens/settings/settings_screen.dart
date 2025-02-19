import 'package:calculator/services/network_services.dart';
import 'package:calculator/utils/constants.dart';
import 'package:calculator/widgets/my_drawer.dart';
import 'package:calculator/widgets/safe_area_with_padding.dart';
import 'package:calculator/widgets/settings_list_tile.dart';
import 'package:calculator/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'calculator_settings_screen.dart';
import 'display_settings_screen.dart';
import 'general_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const route = '/settings';
  static const _key = ValueKey(route);

  const SettingsScreen() : super(key: _key);

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      height: 2,
      indent: 18,
      endIndent: 18,
    );

    final generalSettingsListTile = SettingsListTile(
      leading: SvgIconData.settings,
      title: 'General Settings',
      onTap: () => _onGeneralSettingsTap(context),
    );
    final calcSettingsListTile = SettingsListTile(
      leading: SvgIconData.calculator,
      title: 'Calculator Settings',
      onTap: () => _onCalculatorSettingsTap(context),
    );
    final displaySettingsListTile = SettingsListTile(
      leading: SvgIconData.display,
      title: 'Display',
      onTap: () => _onDisplaySettingsTap(context),
    );

    final rateUsListTile = SettingsListTile(
      leading: SvgIconData.star,
      title: 'Rate us',
      onTap: () async => await _onRateUsTap(),
    );
    final shareAppListTile = SettingsListTile(
      leading: SvgIconData.share,
      title: 'Share app',
      onTap: () async => await _onShareAppTap(),
    );
    final privacyPolicyListTile = SettingsListTile(
      leading: SvgIconData.security,
      title: 'Privacy policy',
      onTap: () async => await _onPrivacyPolicyTap(),
    );

    final card1Settings = <SettingsListTile>[
      generalSettingsListTile,
      calcSettingsListTile,
      displaySettingsListTile,
    ];

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeAreaWithPadding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: card1Settings.length,
                  itemBuilder: (context, index) => card1Settings[index],
                  separatorBuilder: (_, __) => divider,
                ),
              ),
              Card(
                child: Column(
                  children: [
                    rateUsListTile,
                    divider,
                    shareAppListTile,
                    divider,
                    privacyPolicyListTile,
                  ],
                ),
              ),
              const Text('Version 1.0.9'),
            ],
          ),
        ),
      ),
    );
  }

  void _onCalculatorSettingsTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CalculatorSettingsScreen(),
      ),
    );
  }

  void _onDisplaySettingsTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DisplaySettingsScreen(),
      ),
    );
  }

  void _onGeneralSettingsTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GeneralSettingsScreen(),
      ),
    );
  }

  Future<void> _onRateUsTap() async {
    await NetworkServices.openPlayStore();
  }

  Future<void> _onShareAppTap() async {
    await Share.share(
      'Check out this awesome calculator app: ${Constants.appUrl}',
    );
  }

  Future<void> _onPrivacyPolicyTap() async {
    await NetworkServices.openPrivacyPolicy();
  }
}
