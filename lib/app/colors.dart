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
    required this.resultsBackground,

    // Calculator Page
    required this.result,
    required this.toogleScientificButtonBackground,
    required this.gridButtonDefaultBackground,
    required this.gridButtonDefaultForeground,
    required this.gridButtonText,
    required this.gridScientificButtonBackground,
    required this.swapScientificButtonBackground,
    required this.toogleRadiansButtonForeground,
    required this.expressionTextFieldOperator,

    //History Page
    required this.historyTileResult,
  });

  //General
  final Color? primary;
  final Color? appBarBackground;
  final Color? scaffoldBackground;
  final Color? primaryText;
  final Color? optionsBackground;
  final Color? resultsBackground;

  // Calculator Page
  final Color? result;
  final Color? toogleScientificButtonBackground;
  final Color? gridButtonDefaultBackground;
  final Color? gridButtonDefaultForeground;
  final Color? gridButtonText;
  final Color? gridScientificButtonBackground;
  final Color? swapScientificButtonBackground;
  final Color? toogleRadiansButtonForeground;
  final Color? expressionTextFieldOperator;

  //History Page
  final Color? historyTileResult;

  @override
  AppColors copyWith({
    //General
    Color? primary,
    Color? appBarBackground,
    Color? scaffoldBackground,
    Color? primaryText,
    Color? optionsBackground,
    Color? resultsBackground,

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
      resultsBackground: resultsBackground ?? this.resultsBackground,

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
      toogleRadiansButtonForeground:
          toogleRadiansButtonForeground ?? this.toogleRadiansButtonForeground,
      expressionTextFieldOperator:
          expressionTextFieldOperator ?? this.expressionTextFieldOperator,

      //History Page
      historyTileResult: historyTileResult ?? this.historyTileResult,
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
      resultsBackground:
          Color.lerp(resultsBackground, other.resultsBackground, t),

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
      toogleRadiansButtonForeground: Color.lerp(
        toogleRadiansButtonForeground,
        other.toogleRadiansButtonForeground,
        t,
      ),
      expressionTextFieldOperator: Color.lerp(
        expressionTextFieldOperator,
        other.expressionTextFieldOperator,
        t,
      ),

      //History Page
      historyTileResult: Color.lerp(
        historyTileResult,
        other.historyTileResult,
        t,
      ),
    );
  }
}

class AppColorsLight {
  // General
  static const Color primary = Colors.orange;
  static const Color appBarBackground = Colors.white;
  static const Color scaffoldBackground = Colors.white;
  static const Color primaryText = Colors.black;
  static const Color optionsBackground = Color(0xFFF1F1F1);
  static const Color resultsBackground = Color(0xFFF1F1F1);

  // Calculator Page
  static const Color result = Color(0xFFAFAFAF);
  static const Color toogleScientificButtonBackground = Color(0xFFF2F4F3);
  static const Color gridButtonDefaultBackground = Color(0xFFF2F4F3);
  static const Color gridButtonDefaultForeground = Colors.black;
  static const Color gridButtonText = Colors.black;
  static const Color gridScientificButtonBackground = Color(0xFFE2E8E6);
  static const Color swapScientificButtonBackground = Color(0xFFE2E8E6);
  static const Color toogleRadiansButtonForeground = primary;

  static const Color expressionTextFieldOperator = primary;

  //History Page
  static const Color historyTileResult = primary;
}

class AppColorsDark {
  // General
  static const Color primary = Colors.orange;
  static const Color appBarBackground = Color(0xFF141118);
  static const Color primaryText = Colors.white;
  static const Color optionsBackground = Color(0xFF222222);
  static const Color resultsBackground = Color(0xFF222222);

  // Calculator Page
  static const Color result = Color(0xFFAFAFAF);
  static const Color toogleScientificButtonBackground = Color(0xFF1D1B20);
  static const Color gridButtonDefaultBackground = Color(0xFF1D1B20);
  static const Color gridButtonDefaultForeground = Colors.black;
  static const Color gridButtonText = Colors.white;
  static const Color gridScientificButtonBackground = Color(0xFF1D1B20);
  static const Color swapScientificButtonBackground = Color(0xFF1D1B20);
  static const Color toogleRadiansButtonForeground = primary;

  static const Color expressionTextFieldOperator = primary;

  //History Page
  static const Color historyTileResult = primary;
}
