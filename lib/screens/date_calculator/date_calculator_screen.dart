import 'package:calculator/app/colors.dart';
import 'package:calculator/widgets/date_field.dart';
import 'package:calculator/widgets/number_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'date_calculator_view_model.dart';

class DateCalculatorScreen extends StatelessWidget {
  const DateCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final viewModelRead = context.read<DateCalculatorViewModel>();

    final Widget startDateField = DateField(
      label: 'From Date',
    );
    final Widget durationField = NumberTextField(
      controller: viewModelRead.durationController,
      focusNode: viewModelRead.durationFocusNode,
      label: 'Duration (days)',
    );
    final Widget endDateField = DateField(
      label: 'To Date',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Calculator'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              startDateField,
              durationField,
              endDateField,
            ],
          ),
        ),
      ),
    );
  }
}
