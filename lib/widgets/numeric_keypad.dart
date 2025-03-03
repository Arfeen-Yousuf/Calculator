import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:calculator/app/colors.dart';
import 'package:calculator/extensions/string.dart';
import 'package:calculator/screens/calculator/calculator_screen.dart';
import 'package:calculator/screens/calculator/calculator_view_model.dart';
import 'package:calculator/utils/constants.dart';
import 'package:calculator/utils/utils.dart';

import 'bottom_sheet_header.dart';
import 'grid_button.dart';
import 'svg_icon.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.controller,
    this.focusNode,
    this.onValueChanged,
    this.allowNegativeNumbers = true,
    this.percentageOnly = false,
    this.integersOnly = false,
    this.maxIntegers = 12,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<double?>? onValueChanged;
  final bool allowNegativeNumbers;
  final bool percentageOnly;
  final bool integersOnly;
  final int maxIntegers;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final appColors = Theme.of(context).extension<AppColors>()!;

    final digitButtons = List<GridButton>.generate(10, (index) {
      return GridButton(
        onPressed: () => addDigit(index),
        text: '$index',
      );
    });
    late final twoZerosButton = GridButton(
      onPressed: addTwoZeros,
      text: '00',
    );

    final backspaceButton = GridButton(
      onPressed: backspace,
      iconData: Icons.backspace_outlined,
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
      onPressed: onEqualPressed,
      text: '=',
      foregroundColor: Colors.white,
      backgroundColor: appColors.primary,
      largeFontSize: true,
    );
    final dotButton = integersOnly
        ? Container()
        : GridButton(
            onPressed: addDot,
            text: '.',
            largeFontSize: true,
          );
    late final toogleSignButton = GridButton(
      onPressed: toogleSign,
      text: '+/${CalculatorConstants.subtraction}',
    );
    final calculatorButton = GridButton(
      onPressed: () async => _showCalculatorBottomSheet(context),
      svgIconData: SvgIconData.calculate,
      foregroundColor: appColors.primary,
      backgroundColor: isLightTheme
          ? appColors.primary?.withAlpha(25)
          : AppColorsDark.gridButtonDefaultBackground,
    );

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
      calculatorButton,
    ];
    final row4Children = [
      allowNegativeNumbers ? toogleSignButton : twoZerosButton,
      digitButtons[0],
      dotButton,
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
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        spacing: 8,
        children: rows,
      ),
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
    final text = controller.text;

    final dotIndex = text.indexOf('.');
    if (dotIndex == -1) {
      String textWithoutSign = text.startsWith(CalculatorConstants.subtraction)
          ? text.substring(1)
          : text;
      textWithoutSign = textWithoutSign.replaceAll(',', '');

      if (textWithoutSign.length >= maxIntegers) {
        showToast('You can enter upto $maxIntegers integers.');
        return;
      }
      if (percentageOnly && textWithoutSign.length >= 2) {
        showToast('You can enter upto 99.99%');
        return;
      }
    } else {
      final decimalPart = text.substring(dotIndex + 1);

      if (decimalPart.length >= 10) {
        showToast('You can enter upto 10 decimals.');
        return;
      }
      if (percentageOnly && decimalPart.length >= 2) {
        showToast('You can enter upto 2 decimals.');
        return;
      }
    }

    switch (text) {
      case '':
        controller.text = '$digit';
      case CalculatorConstants.subtraction:
        controller.text = '${CalculatorConstants.subtraction}$digit';
      case '0':
        controller.text = '$digit';
      case '${CalculatorConstants.subtraction}0':
        controller.text = '${CalculatorConstants.subtraction}$digit';
      default:
        controller.text = '$text$digit';
    }

    finalStep();
  }

  void addTwoZeros() {
    final text = controller.text;

    final dotIndex = text.indexOf('.');
    if (dotIndex == -1) {
      final textWithoutSign = text.startsWith(CalculatorConstants.subtraction)
          ? text.removeFirst()
          : text;
      if (textWithoutSign.replaceAll(',', '').length >= maxIntegers - 1) {
        showToast('You can enter upto $maxIntegers integers.');
        return;
      }
    } else {
      final decimalPart = text.substring(dotIndex + 1);
      if (decimalPart.length >= 10) {
        showToast('You can enter upto 10 decimals.');
        return;
      }
    }

    switch (text) {
      case '':
        controller.text = '0';
      case CalculatorConstants.subtraction:
        controller.text = '${CalculatorConstants.subtraction}0';
      case '0':
        return;
      case '${CalculatorConstants.subtraction}0':
        return;
      default:
        controller.text = '${text}00';
    }

    finalStep();
  }

  void addDot() {
    final text = controller.text;
    if (text.contains('.')) return;

    switch (text) {
      case '':
        controller.text = '0.';
      case CalculatorConstants.subtraction:
        controller.text = '${CalculatorConstants.subtraction}0.';
      case '0':
        controller.text = '0.';
      case '${CalculatorConstants.subtraction}0':
        controller.text = '${CalculatorConstants.subtraction}0.';
      default:
        controller.text = '$text.';
    }

    finalStep();
  }

  void toogleSign() {
    final text = controller.text;
    if (text.startsWith(CalculatorConstants.subtraction)) {
      controller.text = text.substring(1);
    } else {
      controller.text = CalculatorConstants.subtraction + text;
    }

    finalStep();
  }

  void backspace() {
    final text = controller.text;
    if (text.isEmpty) return;
    if (text.length == 1) clear();

    controller.text = text.removeLast();
    if (controller.text == CalculatorConstants.subtraction) {
      onValueChanged?.call(null);
      return;
    }

    finalStep();
  }

  void clear() {
    controller.clear();
    onValueChanged?.call(null);
  }

  void onEqualPressed() => focusNode?.unfocus();

  void finalStep() {
    final text = controller.text
        .replaceAll(',', '')
        .replaceFirst(CalculatorConstants.subtraction, '-');
    if (text.isEmpty) return;
    final dotIndex = text.indexOf('.');

    if (dotIndex == -1) {
      final value = int.parse(text);
      controller.text = (value < 0)
          ? '${CalculatorConstants.subtraction}${numberFormatter.format(-value)}'
          : numberFormatter.format(value);
      onValueChanged?.call(value.toDouble());
    } else {
      final value = double.tryParse(text);
      onValueChanged?.call(value);
    }
  }

  void _showCalculatorBottomSheet(BuildContext context) async {
    final appColors = Theme.of(context).extension<AppColors>()!;

    final result = await showModalBottomSheet<String?>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight * 0.8,
              padding: const EdgeInsets.only(top: 6, left: 8),
              decoration: BoxDecoration(
                color: appColors.scaffoldBackground,
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(20),
                  topEnd: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const BottomSheetHeader(title: 'Calculator'),
                  Expanded(
                    child: ChangeNotifierProvider(
                      create: (context) => CalculatorViewModel(
                        context,
                        isInBottomSheet: true,
                      ),
                      child: const CalculatorScreen(),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );

    if (result != null) {
      final text = result
          .replaceAll(',', '')
          .replaceFirst(CalculatorConstants.subtraction, '-');
      if (text.isEmpty) return;
      final value = double.parse(text);

      if (percentageOnly && (value < 0 || value > 100)) {
        showToast('Percentage must be in the range [0, 100].');
      } else if (!allowNegativeNumbers && value < 0) {
        showToast('Result must be positive.');
      } else if (integersOnly && !(value.toInt() == value)) {
        showToast('Result must be an integer.');
      } else {
        controller.text = result;
        focusNode?.requestFocus();
        await Future.delayed(const Duration(microseconds: 500));

        onValueChanged?.call(value);
      }
    }
  }
}
