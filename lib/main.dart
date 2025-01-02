import 'package:calculator/screens/history/history_view_model.dart';
import 'package:calculator/services/history_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'screens/calculator/calculator_screen.dart';
import 'screens/calculator/calculator_view_model.dart';
import 'app/colors.dart';
import 'screens/discount_calculator/discount_calculator_screen.dart';
import 'screens/discount_calculator/discount_calculator_view_model.dart';
import 'screens/unit_converter/unit_converter_view_model.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the history database and store the reference.
  Database db = await openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'history_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        '''CREATE TABLE $tableHistory(
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDateTime TEXT NOT NULL,
            $columnExpression TEXT NOT NULL, 
            $columnResult REAL NOT NULL)
        ''',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  HistoryDatabaseManager.db = db;
  int totalHistoryLogs = await HistoryDatabaseManager.historyLogsCount();
  final initialHistoryLogs = await HistoryDatabaseManager.historyLogs(
    limit: Constants.historyLogsPerPage,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HistoryViewModel(
            totalHistoryLogs: totalHistoryLogs,
            initialHistoryLogs: initialHistoryLogs,
          ),
        ),
        ChangeNotifierProvider(create: (_) => CalculatorViewModel()),
        ChangeNotifierProvider(create: (_) => UnitConverterViewModel()),
        ChangeNotifierProvider(create: (_) => DiscountCalculatorViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.system,
      //home: const CalculatorScreen(),
      home: const DiscountCalculatorScreen(),
    );
  }

  ThemeData lightThemeData(BuildContext context) {
    return ThemeData().copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColorsLight.primary),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsLight.appBarBackground,
        surfaceTintColor: Colors.transparent,
      ),
      scaffoldBackgroundColor: AppColorsLight.scaffoldBackground,
      iconTheme: const IconThemeData(color: AppColorsLight.primary),
      primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
            bodyColor: AppColorsLight.primaryText,
            displayColor: AppColorsLight.primaryText,
          ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsDark.primary,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        const AppColors(
          //General
          primary: AppColorsLight.primary,
          appBarBackground: AppColorsLight.appBarBackground,
          scaffoldBackground: AppColorsLight.scaffoldBackground,
          primaryText: AppColorsLight.primaryText,
          optionsBackground: AppColorsLight.optionsBackground,
          resultsBackground: AppColorsLight.resultsBackground,

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

          //History Page
          historyTileResult: AppColorsLight.historyTileResult,
        ),
      ],
    );
  }

  ThemeData darkThemeData(BuildContext context) {
    return ThemeData.dark().copyWith(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsDark.primary,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        const AppColors(
          //General
          primary: AppColorsDark.primary,
          appBarBackground: AppColorsDark.appBarBackground,
          scaffoldBackground: null,
          primaryText: AppColorsDark.primaryText,
          optionsBackground: AppColorsDark.optionsBackground,
          resultsBackground: AppColorsDark.resultsBackground,

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

          //History Page
          historyTileResult: AppColorsDark.historyTileResult,
        ),
      ],
    );
  }
}
