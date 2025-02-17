import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    //General
    required this.primary,
    required this.appBarBackground,
    required this.scaffoldBackground,
    required this.primaryText,
    required this.optionsBackground,
    required this.cardBackground,

    //Drawer
    required this.selectedDrawerTile,

    //Home Page
    required this.homeBackground,
    required this.homeTile,

    // Calculator Page
    required this.result,
    required this.toogleScientificButtonBackground,
    required this.gridButtonDefaultBackground,
    required this.gridButtonDefaultForeground,
    required this.gridButtonText,
    required this.gridScientificButtonBackground,
    required this.swapScientificButtonBackground,
  });

  //General
  final Color? primary;
  final Color? appBarBackground;
  final Color? scaffoldBackground;
  final Color? primaryText;
  final Color? optionsBackground;
  final Color? cardBackground;

  //Drawer
  final Color? selectedDrawerTile;

  //Home Page
  final Color? homeBackground;
  final Color? homeTile;

  // Calculator Page
  final Color? result;
  final Color? toogleScientificButtonBackground;
  final Color? gridButtonDefaultBackground;
  final Color? gridButtonDefaultForeground;
  final Color? gridButtonText;
  final Color? gridScientificButtonBackground;
  final Color? swapScientificButtonBackground;

  @override
  AppColors copyWith({
    //General
    Color? primary,
    Color? appBarBackground,
    Color? scaffoldBackground,
    Color? primaryText,
    Color? optionsBackground,
    Color? cardBackground,

    //Drawer
    Color? selectedDrawerTile,

    //Home Page
    Color? homeBackground,
    Color? homeTile,

    // Calculator Page
    Color? result,
    Color? toogleScientificButtonBackground,
    Color? gridButtonDefaultBackground,
    Color? gridButtonDefaultForeground,
    Color? gridButtonText,
    Color? gridScientificButtonBackground,
    Color? swapScientificButtonBackground,
    Color? toogleRadiansButtonForeground,
    Color? expressionTextFieldOperator,

    //History Page
    Color? historyTileResult,
  }) {
    return AppColors(
      //General
      primary: primary ?? this.primary,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      primaryText: primaryText ?? this.primaryText,
      optionsBackground: optionsBackground ?? this.optionsBackground,
      cardBackground: cardBackground ?? this.cardBackground,

      //Drawer
      selectedDrawerTile: selectedDrawerTile ?? this.selectedDrawerTile,

      //Home Page
      homeBackground: homeBackground ?? this.homeBackground,
      homeTile: homeTile ?? this.homeTile,

      // Calculator Page
      result: result ?? this.result,
      toogleScientificButtonBackground: toogleScientificButtonBackground ??
          this.toogleScientificButtonBackground,
      gridButtonDefaultBackground:
          gridButtonDefaultBackground ?? this.gridButtonDefaultBackground,
      gridButtonDefaultForeground:
          gridButtonDefaultForeground ?? this.gridButtonDefaultForeground,
      gridButtonText: gridButtonText ?? this.gridButtonText,
      gridScientificButtonBackground:
          gridScientificButtonBackground ?? this.gridScientificButtonBackground,
      swapScientificButtonBackground:
          swapScientificButtonBackground ?? this.swapScientificButtonBackground,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      //General
      primary: Color.lerp(primary, other.primary, t),
      appBarBackground: Color.lerp(appBarBackground, other.appBarBackground, t),
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t),
      primaryText: Color.lerp(primaryText, other.primaryText, t),
      optionsBackground:
          Color.lerp(optionsBackground, other.optionsBackground, t),
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t),

      //Drawer
      selectedDrawerTile:
          Color.lerp(selectedDrawerTile, other.selectedDrawerTile, t),

      //Home Page
      homeBackground: Color.lerp(homeBackground, other.homeBackground, t),
      homeTile: Color.lerp(homeTile, other.homeTile, t),

      // Calculator Page
      result: Color.lerp(result, other.result, t),
      toogleScientificButtonBackground: Color.lerp(
        toogleScientificButtonBackground,
        other.toogleScientificButtonBackground,
        t,
      ),
      gridButtonDefaultBackground: Color.lerp(
        gridButtonDefaultBackground,
        other.gridButtonDefaultBackground,
        t,
      ),
      gridButtonDefaultForeground: Color.lerp(
        gridButtonDefaultForeground,
        other.gridButtonDefaultForeground,
        t,
      ),
      gridButtonText: Color.lerp(gridButtonText, other.gridButtonText, t),
      gridScientificButtonBackground: Color.lerp(
        gridScientificButtonBackground,
        other.gridScientificButtonBackground,
        t,
      ),
      swapScientificButtonBackground: Color.lerp(
        swapScientificButtonBackground,
        other.swapScientificButtonBackground,
        t,
      ),
    );
  }
}

class AppColorsLight {
  // General
  static const appBarBackground = Colors.white;
  static const scaffoldBackground = Colors.white;
  static const primaryText = Colors.black;
  static const optionsBackground = Color(0xFFF1F1F1);
  static const cardBackground = Color(0xFFF1F1F1);

  //Drawer
  static const selectedDrawerTile = Color(0xFFF1F1F1);

  //Home Page
  static const homeBackground = Color(0xFFF2F4F3);
  static const homeTile = Colors.white;

  // Calculator Page
  static const result = Color(0xFFAFAFAF);
  static const toogleScientificButtonBackground = Color(0xFFF2F4F3);
  static const gridButtonDefaultBackground = Color(0xFFF2F4F3);
  static const gridButtonDefaultForeground = Colors.black;
  static const gridButtonText = Colors.black;
  static const gridScientificButtonBackground = Color(0xFFE2E8E6);
  static const swapScientificButtonBackground = Color(0xFFE2E8E6);
}

class AppColorsDark {
  // General
  static const appBarBackground = Color(0xFF141118);
  static const primaryText = Colors.white;
  static const optionsBackground = Color(0xFF222222);
  static const cardBackground = Color(0xFF222222);

  //Drawer
  static const selectedDrawerTile = Color(0xFF333333);

  //Home
  static const homeTile = Color(0xFF1D1B20);

  // Calculator Page
  static const result = Color(0xFFAFAFAF);
  static const toogleScientificButtonBackground = Color(0xFF1D1B20);
  static const gridButtonDefaultBackground = Color(0xFF1D1B20);
  static const gridButtonDefaultForeground = Colors.black;
  static const gridButtonText = Colors.white;
  static const gridScientificButtonBackground = Color(0xFF1D1B20);
  static const swapScientificButtonBackground = Color(0xFF1D1B20);
}
