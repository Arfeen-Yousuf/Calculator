import 'package:calculator/app/colors.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'grid_button.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.controller,
    this.onNumChanged,
  });

  final TextEditingController controller;
  final void Function(double?)? onNumChanged;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;

    final digitButtons = List<GridButton>.generate(10, (index) {
      return GridButton(
        onPressed: () => addDigit(index),
        text: '$index',
      );
    });
    final twoZerosButton = GridButton(
      onPressed: () {},
      text: '00',
    );

    final backspaceButton = GridButton(
      onPressed: backspace,
      iconData: Icons.backspace,
      foregroundColor: appColors.primary,
      backgroundColor: isLightTheme
          ? appColors.primary?.withAlpha(25)
          : AppColorsDark.gridButtonDefaultBackground,
    );
    final resetButton = GridButton(
        onPressed: clear,
        text: 'C',
        foregroundColor: appColors.primary,
        backgroundColor: isLightTheme
            ? appColors.primary?.withAlpha(25)
            : AppColorsDark.gridButtonDefaultBackground);
    final equalsButton = GridButton(
      onPressed: () {},
      text: '=',
      foregroundColor: Colors.white,
      backgroundColor: appColors.primary,
      largeFontSize: true,
    );
    final dotButton = GridButton(
      onPressed: () {},
      text: '.',
      largeFontSize: true,
    );
    final toogleSignButton = GridButton(
        onPressed: () {},
        text: '+/${CalculatorConstants.subtraction}',
        foregroundColor: appColors.primary,
        backgroundColor: isLightTheme
            ? appColors.primary?.withAlpha(25)
            : AppColorsDark.gridButtonDefaultBackground);

    const rowItemsSpacing = 8.0;

    final row1Children = [
      digitButtons[7],
      digitButtons[8],
      digitButtons[9],
      backspaceButton,
    ];
    final row2Children = [
      digitButtons[4],
      digitButtons[5],
      digitButtons[6],
      resetButton,
    ];
    final row3Children = [
      digitButtons[1],
      digitButtons[2],
      digitButtons[3],
      toogleSignButton,
    ];
    final row4Children = [
      twoZerosButton,
      dotButton,
      digitButtons[0],
      equalsButton,
    ];

    final rowsChildren = [
      row1Children,
      row2Children,
      row3Children,
      row4Children,
    ];

    // Create rows using the helper function
    final rows = rowsChildren
        .map((children) =>
            Expanded(child: createGridRow(children, rowItemsSpacing)))
        .toList();

    // Return the column containing all rows
    return Column(
      spacing: 8,
      children: rows,
    );
  }

  // Helper function to create a grid row with the specified children
  Row createGridRow(List<Widget> children, double spacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing,
      children: children.map((button) => Expanded(child: button)).toList(),
    );
  }

  void addDigit(int digit) {
    if (controller.text.isEmpty) {
      controller.text = '$digit';
      onNumChanged?.call(digit.toDouble());
      return;
    }

    final (cursorPosition, textBeforeCursor, textAfterCursor) =
        cursorRelativeText();

    if (textAfterCursor.startsWith('-')) return;
    if (textBeforeCursor.isEmpty && textAfterCursor.startsWith('0')) return;

    //final noOfDigitsAfterCursor = textAfterCursor.replaceAll('.', '').length;
    String newNumberStr = '$textBeforeCursor$digit$textAfterCursor';
    double newNumber = double.parse(newNumberStr);

    final numberFormatter = NumberFormat('#,##0.##########');
    controller.text = numberFormatter.format(newNumber);
  }

  void backspace() {
    final (cursorPosition, textBeforeCursor, textAfterCursor) =
        cursorRelativeText();

    if (textBeforeCursor.isEmpty) return;
    String newNumberStr =
        textBeforeCursor.substring(0, textBeforeCursor.length - 1) +
            textAfterCursor;
    double newNumber = double.parse(newNumberStr);

    final numberFormatter = NumberFormat('#,##0.##########');
    controller.text = numberFormatter.format(newNumber);
  }

  void clear() {
    controller.clear();
    onNumChanged?.call(null);
  }

  (int, String, String) cursorRelativeText() {
    final text = controller.text;

    int cursorPosition = controller.selection.base.offset;
    if (cursorPosition == -1) {
      cursorPosition = 0;
    }

    final textBeforeCursor =
        text.substring(0, cursorPosition).replaceAll(',', '');
    final textAfterCursor = text.substring(cursorPosition).replaceAll(',', '');
    return (cursorPosition, textBeforeCursor, textAfterCursor);
  }
}
