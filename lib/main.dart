import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/calculator/calculator_screen.dart';
import 'screens/calculator/calculator_view_model.dart';
import 'app/colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalculatorViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      home: CalculatorScreen(),
    );
  }

  ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColorsLight.primary),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorsLight.appBarBackground,
        surfaceTintColor: Colors.transparent,
      ),
      scaffoldBackgroundColor: AppColorsLight.scaffoldBackground,
      iconTheme: IconThemeData(color: AppColorsLight.primary),
      primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
            bodyColor: AppColorsLight.primaryText,
            displayColor: AppColorsLight.primaryText,
          ),
      useMaterial3: true,
    ).copyWith(
      extensions: <ThemeExtension<dynamic>>[
        const AppColors(
          //General
          primary: AppColorsLight.primary,
          appBarBackground: AppColorsLight.appBarBackground,
          scaffoldBackground: AppColorsLight.scaffoldBackground,
          primaryText: AppColorsLight.primaryText,

          //Calculator page
          result: AppColorsLight.result,
          toogleScientificButtonBackground:
              AppColorsLight.toogleScientificButtonBackground,
          gridButtonDefaultBackground:
              AppColorsLight.gridButtonDefaultBackground,
          gridButtonDefaultForeground:
              AppColorsLight.gridButtonDefaultForeground,
          gridButtonText: AppColorsLight.gridButtonText,
          gridScientificButtonBackground:
              AppColorsLight.gridScientificButtonBackground,
          swapScientificButtonBackground:
              AppColorsLight.swapScientificButtonBackground,
          toogleRadiansButtonForeground:
              AppColorsLight.toogleRadiansButtonForeground,
          expressionTextFieldOperator:
              AppColorsLight.expressionTextFieldOperator,
        ),
      ],
    );
  }

  ThemeData darkThemeData(BuildContext context) {
    return ThemeData.dark(useMaterial3: true).copyWith(
      extensions: <ThemeExtension<dynamic>>[
        const AppColors(
          //General
          primary: AppColorsDark.primary,
          appBarBackground: AppColorsDark.appBarBackground,
          scaffoldBackground: AppColorsDark.scaffoldBackground,
          primaryText: AppColorsDark.primaryText,

          //Calculator page
          result: AppColorsDark.result,
          toogleScientificButtonBackground:
              AppColorsDark.toogleScientificButtonBackground,
          gridButtonDefaultBackground:
              AppColorsDark.gridButtonDefaultBackground,
          gridButtonDefaultForeground:
              AppColorsDark.gridButtonDefaultForeground,
          gridButtonText: AppColorsDark.gridButtonText,
          gridScientificButtonBackground:
              AppColorsDark.gridScientificButtonBackground,
          swapScientificButtonBackground:
              AppColorsDark.swapScientificButtonBackground,
          toogleRadiansButtonForeground:
              AppColorsDark.toogleRadiansButtonForeground,
          expressionTextFieldOperator:
              AppColorsDark.expressionTextFieldOperator,
        ),
      ],
    );
  }
}
