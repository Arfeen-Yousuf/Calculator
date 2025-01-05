import 'package:flutter/material.dart';

import 'duration/date_duration_calculator_screen_body.dart';
import 'from_to/date_from_to_calculator_screen_body.dart';

class DateCalculatorScreen extends StatelessWidget {
  const DateCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
