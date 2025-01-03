import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

class ResultsCard extends StatelessWidget {
  const ResultsCard({super.key, required this.results});

  final List<MapEntry<String, double?>> results;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    final resultsLabelTextStyle =
        TextTheme.of(context).labelLarge?.copyWith(fontSize: 18);
    final keyTextStyle =
        TextTheme.of(context).bodyMedium?.copyWith(fontSize: 15);
    final valueTextStyle = TextTheme.of(context).titleLarge?.copyWith(
          color: appColors.primary,
          fontWeight: FontWeight.bold,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          'Results',
          style: resultsLabelTextStyle,
        ),
        Card(
          color: appColors.resultsBackground,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 10,
            ),
            child: Column(
              spacing: 8,
              children: results.map((entry) {
                return Row(
                  children: [
                    Text(entry.key, style: keyTextStyle),
                    const Spacer(),
                    Text(
                      entry.value?.toStringAsFixed(2) ?? '--',
                      style: valueTextStyle,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
