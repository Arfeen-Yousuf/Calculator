import 'package:calculator/app/colors.dart';
import 'package:calculator/screens/date_calculator/date_calculator_screen.dart';
import 'package:calculator/screens/discount_calculator/discount_calculator_screen.dart';
import 'package:calculator/screens/fuel_calculator/fuel_calculator_screen.dart';
import 'package:calculator/screens/settings/settings_screen.dart';
import 'package:calculator/screens/unit_converter/unit_converter_screen.dart';
import 'package:flutter/material.dart';

import 'svg_icon.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Drawer(
      backgroundColor: appColors.scaffoldBackground,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.calculate,
                size: 50,
                color: appColors.primary,
              ),
            ),
          ),
          const _DrawerListTile(
            leadingSvgIconData: SvgIconData.ruler,
            title: 'Unit Converter',
            destination: UnitConverterScreen(),
          ),
          const _DrawerListTile(
            leadingSvgIconData: SvgIconData.discount,
            title: 'Discount Calculator',
            destination: DiscountCalculatorScreen(),
          ),
          const _DrawerListTile(
            leadingSvgIconData: SvgIconData.calendar,
            title: 'Date Calculator',
            destination: DateCalculatorScreen(),
          ),
          const _DrawerListTile(
            leadingSvgIconData: SvgIconData.fuel,
            title: 'Fuel Calculator',
            destination: FuelCalculatorScreen(),
          ),
          const _DrawerListTile(
            leadingSvgIconData: SvgIconData.settings,
            title: 'Settings',
            destination: SettingsScreen(),
          ),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  const _DrawerListTile({
    required this.leadingSvgIconData,
    required this.title,
    required this.destination,
  });

  final SvgIconData leadingSvgIconData;
  final String title;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgIcon(
        leadingSvgIconData,
        size: 25,
      ),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      },
    );
  }
}
