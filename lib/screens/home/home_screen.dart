import 'package:calculator/app/colors.dart';
import 'package:calculator/utils/screen_data.dart';
import 'package:calculator/widgets/my_drawer.dart';
import 'package:calculator/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/';
  static const _key = ValueKey(route);

  const HomeScreen() : super(key: _key);

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    final screensData = ScreenData.screens;

    return Scaffold(
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
      key: super.key,
      leading: SvgIcon(
        screenData.svgIconData,
        color: appColors.primary,
        size: 30,
      ),
      title: Text(screenData.title),
      onTap: () => Navigator.pushNamed(
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
