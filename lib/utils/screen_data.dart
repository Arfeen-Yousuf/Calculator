import 'package:calculator/screens/calculator/calculator_screen.dart';
import 'package:calculator/screens/currency_converter/currency_converter_screen.dart';
import 'package:calculator/screens/date_calculator/date_calculator_screen.dart';
import 'package:calculator/screens/discount_calculator/discount_calculator_screen.dart';
import 'package:calculator/screens/fuel_calculator/fuel_calculator_screen.dart';
import 'package:calculator/screens/home/home_screen.dart';
import 'package:calculator/screens/settings/settings_screen.dart';
import 'package:calculator/screens/unit_converter/unit_converter_screen.dart';
import 'package:calculator/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class ScreenData {
  ScreenData._(
    this.svgIconData,
    this.title,
    this.route,
    this.screen,
  );

  final SvgIconData svgIconData;
  final String title;
  final String route;
  final Widget screen;

  static final List<ScreenData> calculatorScreens = List.unmodifiable([
    calculator,
    unitConverter,
    currencyConverter,
    discountCalculator,
    dateCalculator,
    fuelCalculator
  ]);

  static final home = ScreenData._(
    SvgIconData.home,
    'Home',
    HomeScreen.route,
    const HomeScreen(),
  );
  static final calculator = ScreenData._(
    SvgIconData.calculator,
    'Basic Calculator',
    CalculatorScreen.route,
    const CalculatorScreen(),
  );
  static final unitConverter = ScreenData._(
    SvgIconData.ruler,
    'Unit Converter',
    UnitConverterScreen.route,
    const UnitConverterScreen(),
  );
  static final currencyConverter = ScreenData._(
    SvgIconData.currency,
    'Currency Converter',
    CurrencyConverterScreen.route,
    const CurrencyConverterScreen(),
  );
  static final discountCalculator = ScreenData._(
    SvgIconData.discount,
    'Discount Calculator',
    DiscountCalculatorScreen.route,
    const DiscountCalculatorScreen(),
  );
  static final dateCalculator = ScreenData._(
    SvgIconData.calendar,
    'Date Calculator',
    DateCalculatorScreen.route,
    const DateCalculatorScreen(),
  );
  static final fuelCalculator = ScreenData._(
    SvgIconData.fuel,
    'Fuel Calculator',
    FuelCalculatorScreen.route,
    const FuelCalculatorScreen(),
  );
  static final settings = ScreenData._(
    SvgIconData.settings,
    'Settings',
    SettingsScreen.route,
    const SettingsScreen(),
  );
}
