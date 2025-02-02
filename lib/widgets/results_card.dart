import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

class ResultsCard extends StatelessWidget {
  const ResultsCard({super.key, required this.results});

  final List<MapEntry<String, Object?>> results;

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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 10,
            ),
            child: Column(
              spacing: 8,
              children: results.map((entry) {
                final entryValue = entry.value;
                final String? entryValueStr = (entryValue is double)
                    ? entryValue.toStringAsFixed(2)
                    : entryValue?.toString();

                return Row(
                  children: [
                    Text(entry.key, style: keyTextStyle),
                    const Spacer(),
                    Text(
                      entryValueStr ?? '--',
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
