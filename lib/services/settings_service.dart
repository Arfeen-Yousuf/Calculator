import 'package:calculator/enums/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings locally
/// using shared_preferences package.
class SettingsService {
  static const themeModeKey = 'themeMode';
  static const themeColorKey = 'themeColor';
  static const keepLastRecordKey = 'keepLastRecord';
  static const decimalPlacesKey = 'decimalPlaces';
  static const startUpCalculatorKey = 'startUpCalculator';
  static const lastExpressionKey = 'lastExp';

  /// Loads the User's preferred ThemeMode from storage.
  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(themeModeKey) ?? 0;
    return ThemeMode.values[themeIndex];
  }

  /// Persists the user's preferred ThemeMode to storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeModeKey, theme.index);
  }

  /// Loads the User's preferred ThemeColor from storage.
  Future<ThemeColor> themeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(themeColorKey) ?? 0;
    return ThemeColor.values[themeIndex];
  }

  /// Persists the user's preferred ThemeColor to storage.
  Future<void> updateThemeColor(ThemeColor themeColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeColorKey, themeColor.index);
  }

  /// Loads the User's preferred setting keepLastRecord from storage.
  Future<bool> keepLastRecord() async {
    final prefs = await SharedPreferences.getInstance();
    final keepLastRecord = prefs.getBool(keepLastRecordKey) ?? true;
    return keepLastRecord;
  }

  /// Persists the user's preferred setting keepLastRecord to storage.
  Future<void> updateKeepLastRecord(bool keepLastRecord) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keepLastRecordKey, keepLastRecord);
  }

  /// Loads the User's preferred decimal places from storage.
  Future<int> decimalPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final decimalPlaces = prefs.getInt(decimalPlacesKey) ?? 5;
    return decimalPlaces;
  }

  /// Persists the user's preferred decimal places keepLastRecord to storage.
  Future<void> updateDecimalPlaces(int decimalPlaces) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(decimalPlacesKey, decimalPlaces);
  }

  /// Loads the User's preferred last calculator from storage.
  Future<int> startUpCalculator() async {
    final prefs = await SharedPreferences.getInstance();
    final startUpCalculator = prefs.getInt(startUpCalculatorKey) ?? 0;
    return startUpCalculator;
  }

  /// Persists the user's preferred start up calculator to storage.
  Future<void> updateStartUpCalculator(int startUpCalculator) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(startUpCalculatorKey, startUpCalculator);
  }

  /// Loads the last expression from storage.
  Future<String> lastExpression() async {
    final prefs = await SharedPreferences.getInstance();
    final lastExpression = prefs.getString(lastExpressionKey) ?? '';
    return lastExpression;
  }

  /// Persists the last expression to storage.
  Future<void> updateLastExpression(String lastExpression) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastExpressionKey, lastExpression);
  }
}
