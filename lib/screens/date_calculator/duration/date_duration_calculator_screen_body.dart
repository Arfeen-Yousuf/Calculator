import 'package:calculator/widgets/date_field.dart';
import 'package:calculator/widgets/results_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'date_duration_calculator_view_model.dart';

class DateDurationCalculatorScreenBody extends StatelessWidget {
  const DateDurationCalculatorScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DateDurationCalculatorViewModel>();
    final viewModelRead = context.read<DateDurationCalculatorViewModel>();

    final Widget startDateField = DateField(
      label: 'From Date',
      dateTime: viewModel.startDate,
      onDateTimeChanged: viewModelRead.onStartDateChanged,
    );
    final Widget endDateField = DateField(
      label: 'From Date',
      dateTime: viewModel.endDate,
      onDateTimeChanged: viewModelRead.onEndDateChanged,
    );
    final Widget durationResult = ResultsCard(
      results: [
        MapEntry('Duration', viewModel.duration),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        spacing: 15,
        children: [
          startDateField,
          endDateField,
          durationResult,
        ],
      ),
    );
  }
}
