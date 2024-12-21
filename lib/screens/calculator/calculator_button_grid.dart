import 'package:calculator/utils/colors.dart';
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
    final resetButton = GridButton(
      onPressed: context.read<CalculatorViewModel>().clear,
      text: 'C',
      foregroundColor: AppColors.primary,
      backgroundColor: AppColors.primary.withAlpha(25),
    );
    final bracketsButton = GridButton(
      onPressed: context.read<CalculatorViewModel>().addBracket,
      text: '( )',
      foregroundColor: AppColors.primary,
      backgroundColor: AppColors.primary.withAlpha(25),
    );

    //Operator buttons
    final percentageButton = OperatorGridButton(
      onPressed: context.read<CalculatorViewModel>().addPercentage,
      text: CalculatorConstants.percentage,
    );
    final divideButton = OperatorGridButton(
      onPressed: context.read<CalculatorViewModel>().addDivision,
      text: CalculatorConstants.division,
    );
    final multiplyButton = OperatorGridButton(
      onPressed: context.read<CalculatorViewModel>().addMultiplication,
      text: CalculatorConstants.multiplication,
    );
    final subtractionButton = OperatorGridButton(
      onPressed: context.read<CalculatorViewModel>().addSubtraction,
      text: CalculatorConstants.subtraction,
    );
    final additionButton = OperatorGridButton(
      onPressed: context.read<CalculatorViewModel>().addAddition,
      text: CalculatorConstants.addition,
    );
    final powerButton = OperatorGridButton(
      onPressed: context.read<CalculatorViewModel>().addPower,
      text: CalculatorConstants.power,
    );

    final digitButtons = List<GridButton>.generate(10, (index) {
      return GridButton(
        onPressed: () => context.read<CalculatorViewModel>().addDigit(index),
        text: '$index',
      );
    });
    final dotButton = GridButton(
      onPressed: context.read<CalculatorViewModel>().addDot,
      text: '.',
      largeFontSize: true,
    );
    final equalsButton = GridButton(
      onPressed: context.read<CalculatorViewModel>().computeResult,
      text: '=',
      foregroundColor: Colors.white,
      backgroundColor: AppColors.primary,
      largeFontSize: true,
    );

    //Scientific buttons
    final swapScientificButton = GridButton(
      onPressed:
          context.read<CalculatorViewModel>().toogleShowScientificInverse,
      iconData: Icons.swap_horiz_outlined,
      backgroundColor: AppColors.swapScientificButtonBackground,
    );

    //Constnts
    late final piButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addConstant(ScientificConstants.pi),
      text: ScientificConstants.pi,
    );
    late final eularButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addConstant(ScientificConstants.eular),
      text: ScientificConstants.eular,
    );
    late final roundButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.round),
      text: ScientificFunctions.round,
    );
    late final phiButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addConstant(ScientificConstants.phi),
      text: ScientificConstants.phi,
    );

    //Roots
    late final squareRootButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.squareRoot),
      text: ScientificFunctions.squareRoot,
    );
    late final cubeRootButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.cubeRoot),
      text: ScientificFunctions.cubeRoot,
    );

    //Trigonometric
    late final sineButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.sine),
      text: ScientificFunctions.sine,
    );
    late final cosineButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.cosine),
      text: ScientificFunctions.cosine,
    );
    late final tangentButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.tangent),
      text: ScientificFunctions.tangent,
    );

    //Inverse trigonometric
    late final sineInverseButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.sineInverse),
      text: ScientificFunctions.sineInverse,
    );
    late final cosineInverseButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.cosineInverse),
      text: ScientificFunctions.cosineInverse,
    );
    late final tangentInverseButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.tangentInverse),
      text: ScientificFunctions.tangentInverse,
    );

    //Hyperbolic
    late final sineHyperbolicButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.sineHyperbolic),
      text: ScientificFunctions.sineHyperbolic,
    );
    late final cosineHyperbolicButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.cosineHyperbolic),
      text: ScientificFunctions.cosineHyperbolic,
    );
    late final tangentHyperbolicButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.tangentHyperbolic),
      text: ScientificFunctions.tangentHyperbolic,
    );

    //Inverse hyperbolic
    late final sineHyperbolicInverseButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.sineHyperbolicInverse),
      text: ScientificFunctions.sineHyperbolicInverse,
    );
    late final cosineHyperbolicInverseButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.cosineHyperbolicInverse),
      text: ScientificFunctions.cosineHyperbolicInverse,
    );
    late final tangentHyperbolicInverseButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.tangentHyperbolicInverse),
      text: ScientificFunctions.tangentHyperbolicInverse,
    );

    //Logs
    late final logButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.logarithm),
      text: ScientificFunctions.logarithm,
    );
    late final naturalLogButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.naturalLogarithm),
      text: ScientificFunctions.naturalLogarithm,
    );

    //Others
    late final absoluteButton = ScientificGridButton(
      onPressed: () => context
          .read<CalculatorViewModel>()
          .addFunction(ScientificFunctions.absolute),
      text: '|x|',
    );
    late final factorialButton = ScientificGridButton(
      onPressed: context.read<CalculatorViewModel>().addFactorial,
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
