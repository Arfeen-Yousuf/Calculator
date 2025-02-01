import 'package:calculator/enums/theme_color.dart';
import 'package:calculator/services/settings_service.dart';
import 'package:flutter/material.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsProvider
/// uses the SettingsService to store and retrieve user settings.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._settingsService);

  final SettingsService _settingsService;

  /// Load the user's settings from the SettingsService.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _themeColor = await _settingsService.themeColor();

    notifyListeners();
  }

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();

    await _settingsService.updateThemeMode(newThemeMode);
  }

  late ThemeColor _themeColor;
  ThemeColor get themeColor => _themeColor;

  /// Update and persist the ThemeColor based on the user's selection.
  Future<void> updateThemeColor(ThemeColor? newThemeColor) async {
    if (newThemeColor == null) return;
    if (newThemeColor == _themeColor) return;

    _themeColor = newThemeColor;
    notifyListeners();

    await _settingsService.updateThemeColor(newThemeColor);
  }
}
