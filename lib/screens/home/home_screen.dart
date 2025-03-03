import 'dart:async';

import 'package:calculator/app/colors.dart';
import 'package:calculator/providers/settings_provider.dart';
import 'package:calculator/screens/calculator/calculator_view_model.dart';
import 'package:calculator/utils/screen_data.dart';
import 'package:calculator/utils/utils.dart';
import 'package:calculator/widgets/my_drawer.dart';
import 'package:calculator/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/';
  static const _key = ValueKey(route);

  const HomeScreen() : super(key: _key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool canPop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    final screensData = ScreenData.calculatorScreens;

    final scaffold = Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: appColors.homeBackground,
      ),
      backgroundColor: appColors.homeBackground,
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: screensData.length,
          itemBuilder: (context, index) => _HomeScreenListTile(
            screenData: screensData[index],
          ),
          separatorBuilder: (_, __) => const SizedBox(
            height: 10,
          ),
        ),
      ),
    );

    if (!context.read<SettingsProvider>().keepLastRecord) {
      return scaffold;
    } else {
      return PopScope(
        canPop: canPop,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          showToast("Press 'Back' once more to exit");
          await saveExpression();
        },
        child: scaffold,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      saveExpression();
    }
  }

  Future<void> saveExpression() async {
    final settingsProvider = context.read<SettingsProvider>();
    if (settingsProvider.keepLastRecord) {
      await settingsProvider.updateLastExpression(
        context.read<CalculatorViewModel>().currentExpression,
      );
    }

    canPop = true;
    Timer(
      const Duration(seconds: 3),
      () => canPop = false,
    );
  }
}

class _HomeScreenListTile extends StatelessWidget {
  const _HomeScreenListTile({
    required this.screenData,
  });

  final ScreenData screenData;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    final destinationRoute = (screenData.screen.key as ValueKey<String>).value;

    return ListTile(
      leading: SvgIcon(
        screenData.svgIconData,
        color: appColors.primary,
        size: 30,
      ),
      title: Text(screenData.title),
      onTap: () => Navigator.restorablePushNamed(
        context,
        destinationRoute,
      ),
      tileColor: appColors.homeTile,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
