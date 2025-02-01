import 'package:calculator/enums/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings locally
/// using shared_preferences package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from storage.
  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    return ThemeMode.values[themeIndex];
  }

  /// Persists the user's preferred ThemeMode to storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', theme.index);
  }

  /// Loads the User's preferred ThemeColor from storage.
  Future<ThemeColor> themeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeColor') ?? 0;
    return ThemeColor.values[themeIndex];
  }

  /// Persists the user's preferred ThemeColor to storage.
  Future<void> updateThemeColor(ThemeColor themeColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColor', themeColor.index);
  }
}
