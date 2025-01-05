import 'package:calculator/utils/utils.dart';
import 'package:calculator/widgets/date_field.dart';
import 'package:calculator/widgets/number_text_field.dart';
import 'package:calculator/widgets/numeric_keypad.dart';
import 'package:calculator/widgets/results_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'date_from_to_calculator_view_model.dart';

class DateFromToCalculatorScreenBody extends StatelessWidget {
  const DateFromToCalculatorScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModelRead = context.read<DateFromToCalculatorViewModel>();

    final Widget startDateField = DateField(
      label: 'From Date',
      dateTime: viewModelRead.startDate,
      onDateTimeChanged: viewModelRead.onStartDateChanged,
    );
    final Widget durationField = NumberTextField(
      controller: viewModelRead.durationController,
      focusNode: viewModelRead.durationFocusNode,
      label: 'Duration (days)',
      hintText: '(Required)',
    );
    final Widget endDateResult = ResultsCard(
      results: [
        MapEntry(
          'To Date',
          dateToString(context.watch<DateFromToCalculatorViewModel>().endDate),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 15,
                children: [
                  startDateField,
                  durationField,
                  endDateResult,
                ],
              ),
            ),
          ),
          if (context
              .watch<DateFromToCalculatorViewModel>()
              .durationFocusNode
              .hasFocus)
            Expanded(
              child: NumericKeypad(
                controller: viewModelRead.durationController,
                focusNode: viewModelRead.durationFocusNode,
                onValueChanged: (double? val) =>
                    viewModelRead.onDurationChanged(val?.toInt()),
                integersOnly: true,
                maxIntegers: 4,
              ),
            ),
        ],
      ),
    );
  }
}
