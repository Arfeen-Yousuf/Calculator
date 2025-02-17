import 'package:calculator/screens/calculator/calculator_screen.dart';
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
    this.screen,
  );

  final SvgIconData svgIconData;
  final String title;
  final Widget screen;

  static final List<ScreenData> screens = List.unmodifiable([
    calculator,
    unitConverter,
    discountCalculator,
    dateCalculator,
    fuelCalculator
  ]);

  static final home = ScreenData._(
    SvgIconData.home,
    'Home',
    const HomeScreen(),
  );
  static final calculator = ScreenData._(
    SvgIconData.calculator,
    'Basic Calculator',
    const CalculatorScreen(),
  );
  static final unitConverter = ScreenData._(
    SvgIconData.ruler,
    'Unit Converter',
    const UnitConverterScreen(),
  );
  static final discountCalculator = ScreenData._(
    SvgIconData.discount,
    'Discount Calculator',
    const DiscountCalculatorScreen(),
  );
  static final dateCalculator = ScreenData._(
    SvgIconData.calendar,
    'Date Calculator',
    const DateCalculatorScreen(),
  );
  static final fuelCalculator = ScreenData._(
    SvgIconData.fuel,
    'Fuel Calculator',
    const FuelCalculatorScreen(),
  );
  static final settings = ScreenData._(
    SvgIconData.settings,
    'Settings',
    const SettingsScreen(),
  );
}
