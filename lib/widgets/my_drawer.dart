import 'dart:developer';

import 'package:calculator/app/colors.dart';
import 'package:calculator/screens/home/home_screen.dart';
import 'package:calculator/utils/screen_data.dart';
import 'package:flutter/material.dart';

import 'svg_icon.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    final screensData = ScreenData.calculatorScreens;

    return Drawer(
      backgroundColor: appColors.scaffoldBackground,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 8,
          ),
          children: [
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.calculate,
                size: 70,
                color: appColors.primary,
              ),
            ),
            const SizedBox(height: 35),
            _DrawerListTile(screenData: ScreenData.home),
            _DrawerListTile(screenData: ScreenData.settings),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              child: Text(
                'Calculators',
                style: TextStyle(
                  color: appColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ...screensData.map(
              (screenData) => _DrawerListTile(screenData: screenData),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  const _DrawerListTile({
    required this.screenData,
  });

  final ScreenData screenData;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    final currentRoute = ModalRoute.of(context)?.settings.name;
    final destinationRoute = (screenData.screen.key as ValueKey<String>).value;
    final selected = (currentRoute == destinationRoute);

    return ListTile(
      selected: selected,
      selectedColor: appColors.primaryText,
      selectedTileColor: appColors.selectedDrawerTile,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: SvgIcon(
        screenData.svgIconData,
        color: appColors.primary,
        size: 25,
      ),
      title: Text(screenData.title),
      onTap: () {
        //Pop the drawer
        Navigator.pop(context);

        if (currentRoute == destinationRoute) {
          return;
        } else if (currentRoute != HomeScreen.route &&
            destinationRoute == HomeScreen.route) {
          log('Route Going to home');
          Navigator.pop(context);
        } else if (currentRoute == HomeScreen.route &&
            destinationRoute != HomeScreen.route) {
          log('Route $destinationRoute pushed');
          Navigator.restorablePushNamed(context, destinationRoute);
        } else {
          log('Route $destinationRoute replaced');
          Navigator.restorablePushReplacementNamed(context, destinationRoute);
        }
      },
    );
  }
}
