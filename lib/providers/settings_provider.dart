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
    _keepLastRecord = await _settingsService.keepLastRecord();
    _lastExpression =
        _keepLastRecord ? (await _settingsService.lastExpression()) : '';
    _decimalPlaces = await _settingsService.decimalPlaces();

    notifyListeners();
  }

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode newThemeMode) async {
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();

    await _settingsService.updateThemeMode(newThemeMode);
  }

  late ThemeColor _themeColor;
  ThemeColor get themeColor => _themeColor;

  /// Update and persist the ThemeColor based on the user's selection.
  Future<void> updateThemeColor(ThemeColor newThemeColor) async {
    if (newThemeColor == _themeColor) return;
    _themeColor = newThemeColor;
    notifyListeners();

    await _settingsService.updateThemeColor(newThemeColor);
  }

  late bool _keepLastRecord;
  bool get keepLastRecord => _keepLastRecord;

  /// Update and persist keep last record setting based on the user's selection.
  Future<void> updateKeepLastRecord(bool keepLastRecord) async {
    if (keepLastRecord == _keepLastRecord) return;
    _keepLastRecord = keepLastRecord;
    notifyListeners();

    await _settingsService.updateKeepLastRecord(keepLastRecord);
  }

  late String _lastExpression;
  String get lastExpression => _lastExpression;

  /// Update and persist keep last expression.
  Future<void> updateLastExpression(String lastExpression) async {
    if (lastExpression == _lastExpression) return;
    _lastExpression = lastExpression;
    notifyListeners();

    await _settingsService.updateLastExpression(lastExpression);
  }

  late int _decimalPlaces;
  int get decimalPlaces => _decimalPlaces;

  /// Update and persist decimal places setting based on the user's selection.
  Future<void> updateDecimalPlaces(int decimalPlaces) async {
    if (decimalPlaces == _decimalPlaces) return;
    _decimalPlaces = decimalPlaces;
    notifyListeners();

    await _settingsService.updateDecimalPlaces(decimalPlaces);
  }
}
