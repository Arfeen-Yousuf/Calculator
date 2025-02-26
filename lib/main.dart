import 'package:calculator/screens/currency_converter/currency_converter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'app/colors.dart';
import 'providers/settings_provider.dart';
import 'screens/calculator/calculator_screen.dart';
import 'screens/calculator/calculator_view_model.dart';
import 'screens/currency_converter/currency_converter_view_model.dart';
import 'screens/date_calculator/date_calculator_screen.dart';
import 'screens/date_calculator/duration/date_duration_calculator_view_model.dart';
import 'screens/date_calculator/from_to/date_from_to_calculator_view_model.dart';
import 'screens/discount_calculator/discount_calculator_screen.dart';
import 'screens/discount_calculator/discount_calculator_view_model.dart';
import 'screens/fuel_calculator/fuel_calculator_screen.dart';
import 'screens/fuel_calculator/fuel_calculator_view_model.dart';
import 'screens/history/history_view_model.dart';
import 'screens/home/home_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/unit_converter/unit_converter_screen.dart';
import 'screens/unit_converter/unit_converter_view_model.dart';
import 'services/history_database.dart';
import 'services/settings_service.dart';
import 'utils/constants.dart';
import 'utils/screen_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //For android 15+
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsProvider(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

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
            $columnResult TEXT NOT NULL)
        ''',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  HistoryDatabaseManager.db = db;
  final totalHistoryLogs = await HistoryDatabaseManager.historyLogsCount();
  final initialHistoryLogs = await HistoryDatabaseManager.historyLogs(
    limit: Constants.historyLogsPerPage,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => settingsController,
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryViewModel(
            totalHistoryLogs: totalHistoryLogs,
            initialHistoryLogs: initialHistoryLogs,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final int startUpCalculator =
        context.read<SettingsProvider>().startUpCalculator;
    final String initialRoute = (startUpCalculator == 0)
        ? ScreenData.home.route
        : ScreenData.calculatorScreens[startUpCalculator - 1].route;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CalculatorViewModel(context),
        ),
        ChangeNotifierProvider(
          create: (context) => UnitConverterViewModel(context),
        ),
        ChangeNotifierProvider(
          create: (context) => CurrencyConverterViewModel(context),
        ),
        ChangeNotifierProvider(create: (_) => DiscountCalculatorViewModel()),
        ChangeNotifierProvider(create: (_) => DateFromToCalculatorViewModel()),
        ChangeNotifierProvider(
          create: (_) => DateDurationCalculatorViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => FuelCalculatorViewModel()),
      ],
      child: MaterialApp(
        title: 'Calculator App',
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        themeMode: context.watch<SettingsProvider>().themeMode,
        initialRoute: initialRoute,
        routes: {
          HomeScreen.route: (context) => const HomeScreen(),
          CalculatorScreen.route: (context) => const CalculatorScreen(),
          UnitConverterScreen.route: (context) => const UnitConverterScreen(),
          CurrencyConverterScreen.route: (context) =>
              const CurrencyConverterScreen(),
          DiscountCalculatorScreen.route: (context) =>
              const DiscountCalculatorScreen(),
          DateCalculatorScreen.route: (context) => const DateCalculatorScreen(),
          FuelCalculatorScreen.route: (context) => const FuelCalculatorScreen(),
          SettingsScreen.route: (context) => const SettingsScreen(),
        },
      ),
    );
  }

  ThemeData lightThemeData(BuildContext context) {
    final primaryColor = context.watch<SettingsProvider>().themeColor.color;

    return ThemeData().copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsLight.appBarBackground,
        surfaceTintColor: Colors.transparent,
      ),
      scaffoldBackgroundColor: AppColorsLight.scaffoldBackground,
      iconTheme: IconThemeData(color: primaryColor),
      //primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
      //      bodyColor: AppColorsLight.primaryText,
      //      displayColor: AppColorsLight.primaryText,
      //    ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: AppColorsLight.scaffoldBackground,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryColor,
        indicatorColor: primaryColor,
        dividerHeight: 0,
      ),
      cardTheme: const CardTheme(
        color: AppColorsLight.cardBackground,
        elevation: 0,
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppColors(
          //General
          primary: primaryColor,
          appBarBackground: AppColorsLight.appBarBackground,
          scaffoldBackground: AppColorsLight.scaffoldBackground,
          primaryText: AppColorsLight.primaryText,
          optionsBackground: AppColorsLight.optionsBackground,
          cardBackground: AppColorsLight.cardBackground,

          //Home Page
          homeBackground: AppColorsLight.homeBackground,
          homeTile: AppColorsLight.homeTile,

          //Drawer
          selectedDrawerTile: AppColorsLight.selectedDrawerTile,

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
        ),
      ],
    );
  }

  ThemeData darkThemeData(BuildContext context) {
    final primaryColor = context.watch<SettingsProvider>().themeColor.color;

    return ThemeData.dark().copyWith(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryColor,
        indicatorColor: primaryColor,
        dividerHeight: 0,
      ),
      cardTheme: const CardTheme(
        color: AppColorsDark.cardBackground,
        elevation: 0,
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppColors(
          //General
          primary: primaryColor,
          appBarBackground: AppColorsDark.appBarBackground,
          scaffoldBackground: null,
          primaryText: AppColorsDark.primaryText,
          optionsBackground: AppColorsDark.optionsBackground,
          cardBackground: AppColorsDark.cardBackground,

          //Drawer
          selectedDrawerTile: AppColorsDark.selectedDrawerTile,

          //Home Page
          homeBackground: null,
          homeTile: AppColorsDark.homeTile,

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
        ),
      ],
    );
  }
}
