import 'package:calculator/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

import 'duration/date_duration_calculator_screen_body.dart';
import 'from_to/date_from_to_calculator_screen_body.dart';

class DateCalculatorScreen extends StatelessWidget {
  static const route = '/date-calculator';
  static const _key = ValueKey(route);

  const DateCalculatorScreen() : super(key: _key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          title: const Text('Date Calculator'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Duration'),
              Tab(text: 'From/To'),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              DateDurationCalculatorScreenBody(),
              DateFromToCalculatorScreenBody(),
            ],
          ),
        ),
      ),
    );
  }
}
