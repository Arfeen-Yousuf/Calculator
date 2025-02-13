import 'package:calculator/services/network_services.dart';
import 'package:calculator/utils/constants.dart';
import 'package:calculator/widgets/safe_area_with_padding.dart';
import 'package:calculator/widgets/settings_list_tile.dart';
import 'package:calculator/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'calculator_settings_screen.dart';
import 'display_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      height: 2,
      indent: 18,
      endIndent: 18,
    );

    final calcSettingsListTile = SettingsListTile(
      leading: SvgIconData.settings,
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

    return Scaffold(
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
                child: Column(
                  children: [
                    calcSettingsListTile,
                    divider,
                    displaySettingsListTile,
                  ],
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
