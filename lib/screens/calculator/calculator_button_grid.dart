import 'package:calculator/app/colors.dart';
import 'package:calculator/utils/constants.dart';
import 'package:calculator/widgets/grid_button.dart';
import 'package:calculator/widgets/operator_grid_button.dart';
import 'package:calculator/widgets/scientific_grid_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'calculator_view_model.dart';

class CalculatorButtonGrid extends StatelessWidget {
  const CalculatorButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;
    final viewModelRead = context.read<CalculatorViewModel>();

    final resetButton = GridButton(
        onPressed: viewModelRead.clear,
        text: 'C',
        foregroundColor: appColors.primary,
        backgroundColor: isLightTheme
            ? appColors.primary?.withAlpha(25)
            : AppColorsDark.gridButtonDefaultBackground);
    final bracketsButton = GridButton(
        onPressed: viewModelRead.addBracket,
        text: '( )',
        foregroundColor: appColors.primary,
        backgroundColor: isLightTheme
            ? appColors.primary?.withAlpha(25)
            : AppColorsDark.gridButtonDefaultBackground);

    //Operator buttons
    final percentageButton = OperatorGridButton(
      onPressed: viewModelRead.addPercentage,
      text: CalculatorConstants.percentage,
    );
    final divideButton = OperatorGridButton(
      onPressed: viewModelRead.addDivision,
      text: CalculatorConstants.division,
    );
    final multiplyButton = OperatorGridButton(
      onPressed: viewModelRead.addMultiplication,
      text: CalculatorConstants.multiplication,
    );
    final subtractionButton = OperatorGridButton(
      onPressed: viewModelRead.addSubtraction,
      text: CalculatorConstants.subtraction,
    );
    final additionButton = OperatorGridButton(
      onPressed: viewModelRead.addAddition,
      text: CalculatorConstants.addition,
    );
    final powerButton = OperatorGridButton(
      onPressed: viewModelRead.addPower,
      text: CalculatorConstants.power,
    );

    final digitButtons = List<GridButton>.generate(10, (index) {
      return GridButton(
        onPressed: () => viewModelRead.addDigit(index),
        text: '$index',
      );
    });
    final dotButton = GridButton(
      onPressed: viewModelRead.addDot,
      text: '.',
      largeFontSize: true,
    );
    final equalsButton = GridButton(
      onPressed: viewModelRead.computeResult,
      text: '=',
      foregroundColor: Colors.white,
      backgroundColor: appColors.primary,
      largeFontSize: true,
    );

    //Scientific buttons
    final swapScientificButton = GridButton(
      onPressed: viewModelRead.toogleShowScientificInverse,
      iconData: Icons.swap_horiz_outlined,
      backgroundColor: appColors.swapScientificButtonBackground,
    );

    //Constnts
    late final piButton = ScientificGridButton(
      onPressed: () => viewModelRead.addConstant(ScientificConstants.pi),
      text: ScientificConstants.pi,
    );
    late final eularButton = ScientificGridButton(
      onPressed: () => viewModelRead.addConstant(ScientificConstants.eular),
      text: ScientificConstants.eular,
    );
    late final roundButton = ScientificGridButton(
      onPressed: () => viewModelRead.addFunction(ScientificFunctions.round),
      text: ScientificFunctions.round,
    );
    late final phiButton = ScientificGridButton(
      onPressed: () => viewModelRead.addConstant(ScientificConstants.phi),
      text: ScientificConstants.phi,
    );

    //Roots
    late final squareRootButton = ScientificGridButton(
      onPressed: () =>
          viewModelRead.addFunction(ScientificFunctions.squareRoot),
      text: ScientificFunctions.squareRoot,
    );
    late final cubeRootButton = ScientificGridButton(
      onPressed: () => viewModelRead.addFunction(ScientificFunctions.cubeRoot),
      text: ScientificFunctions.cubeRoot,
    );

    //Trigonometric
    late final sineButton = ScientificGridButton(
      onPressed: () => viewModelRead.addFunction(ScientificFunctions.sine),
      text: ScientificFunctions.sine,
    );
    late final cosineButton = ScientificGridButton(
      onPressed: () => viewModelRead.addFunction(ScientificFunctions.cosine),
      text: ScientificFunctions.cosine,
    );
    late final tangentButton = ScientificGridButton(
      onPressed: () => viewModelRead.addFunction(ScientificFunctions.tangent),
      text: ScientificFunctions.tangent,
    );

    //Inverse trigonometric
    late final sineInverseButton = ScientificGridButton(
      onPressed: () =>
          viewModelRead.addFunction(ScientificFunctions.sineInverse),
      text: ScientificFunctions.sineInverse,
    );
    late final cosineInverseButton = ScientificGridButton(
      onPressed: () =>
          viewModelRead.addFunction(ScientificFunctions.cosineInverse),
      text: ScientificFunctions.cosineInverse,
    );
    late final tangentInverseButton = ScientificGridButton(
      onPressed: () =>
          viewModelRead.addFunction(ScientificFunctions.tangentInverse),
      text: ScientificFunctions.tangentInverse,
    );

    //Hyperbolic
    late final sineHyperbolicButton = ScientificGridButton(
      onPressed: () =>
          viewModelRead.addFunction(ScientificFunctions.sineHyperbolic),
      text: ScientificFunctions.sineHyperbolic,
    );
    late final cosineHyperbolicButton = ScientificGridButton(
      onPressed: () =>
          viewModelRead.addFunction(ScientificFunctions.cosineHyperbolic),
      text: ScientificFunctions.cosineHyperbolic,
    );
    late final tangentHyperbolicButton = ScientificGridButton(
      onPressed: () =>
          viewModelRead.addFunction(ScientificFunctions.tangentHyperbolic),
      text: ScientificFunctions.tangentHyperbolic,
    );

    //Inverse hyperbolic
    late final sineHyperbolicInverseButton = ScientificGridButton(
      onPressed: () =>
          viewModelRead.addFunction(ScientificFunctions.sineHyperbolicInverse),
      text: ScientificFunctions.sineHyperbolicInverse,
    );
    late final cosineHyperbolicInverseButton = ScientificGridButton(
      onPressed: () => viewModelRead
          .addFunction(ScientificFunctions.cosineHyperbolicInverse),
      text: ScientificFunctions.cosineHyperbolicInverse,
    );
    late final tangentHyperbolicInverseButton = ScientificGridButton(
      onPressed: () => viewModelRead
          .addFunction(ScientificFunctions.tangentHyperbolicInverse),
      text: ScientificFunctions.tangentHyperbolicInverse,
    );

    //Logs
    late final logButton = ScientificGridButton(
      onPressed: () => viewModelRead.addFunction(ScientificFunctions.logarithm),
      text: ScientificFunctions.logarithm,
    );
    late final naturalLogButton = ScientificGridButton(
      onPressed: () =>
          viewModelRead.addFunction(ScientificFunctions.naturalLogarithm),
      text: ScientificFunctions.naturalLogarithm,
    );

    //Others
    late final absoluteButton = ScientificGridButton(
      onPressed: () => viewModelRead.addFunction(ScientificFunctions.absolute),
      text: '|x|',
    );
    late final factorialButton = ScientificGridButton(
      onPressed: viewModelRead.addFactorial,
      text: 'x!',
    );

    late final scienceRow1Children =
        context.watch<CalculatorViewModel>().showScientificInverse
            ? [
                swapScientificButton,
                sineInverseButton,
                sineHyperbolicInverseButton,
                cubeRootButton,
              ]
            : [
                swapScientificButton,
                sineButton,
                sineHyperbolicButton,
                squareRootButton,
              ];
    late final scienceRow2Children =
        context.watch<CalculatorViewModel>().showScientificInverse
            ? [
                roundButton,
                cosineInverseButton,
                cosineHyperbolicInverseButton,
                naturalLogButton,
              ]
            : [
                piButton,
                cosineButton,
                cosineHyperbolicButton,
                logButton,
              ];
    late final scienceRow3Children =
        context.watch<CalculatorViewModel>().showScientificInverse
            ? [
                phiButton,
                tangentInverseButton,
                tangentHyperbolicInverseButton,
                factorialButton,
              ]
            : [
                eularButton,
                tangentButton,
                tangentHyperbolicButton,
                absoluteButton,
              ];

    final rowItemsSpacing = 8.0;

    final row1Children = [
      resetButton,
      bracketsButton,
      percentageButton,
      divideButton,
    ];
    final row2Children = [
      digitButtons[7],
      digitButtons[8],
      digitButtons[9],
      multiplyButton,
    ];
    final row3Children = [
      digitButtons[4],
      digitButtons[5],
      digitButtons[6],
      subtractionButton,
    ];
    final row4Children = [
      digitButtons[1],
      digitButtons[2],
      digitButtons[3],
      additionButton,
    ];
    final row5Children = [
      dotButton,
      digitButtons[0],
      equalsButton,
      powerButton,
    ];

    final rowsChildren = [
      if (context.watch<CalculatorViewModel>().isScientific) ...[
        scienceRow1Children,
        scienceRow2Children,
        scienceRow3Children,
      ],
      row1Children,
      row2Children,
      row3Children,
      row4Children,
      row5Children,
    ];

    // Create rows using the helper function
    final rows = rowsChildren
        .map((children) =>
            Expanded(child: createGridRow(children, rowItemsSpacing)))
        .toList();

    // Return the column containing all rows
    return Column(
      spacing: context.watch<CalculatorViewModel>().isScientific ? 4 : 8,
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
}
