import 'package:calculator/app/colors.dart';
import 'package:calculator/screens/unit_converter/unit_converter_screen.dart';
import 'package:calculator/utils/constants.dart';
import 'package:calculator/utils/utils.dart';
import 'package:calculator/widgets/grid_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'calculator_button_grid.dart';
import 'calculator_view_model.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final appColors = Theme.of(context).extension<AppColors>()!;

    final viewModelRead = context.read<CalculatorViewModel>();

    final historyButton = IconButton(
      onPressed: () => viewModelRead.onHistoryButtonTapped(context),
      icon: const Icon(Icons.history_rounded),
    );
    final unitConverterButton = IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const UnitConverterScreen(),
          ),
        );
      },
      icon: const Icon(Icons.transform_rounded),
    );

    final textField = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: LayoutBuilder(builder: (context, constraints) {
        return TextField(
          controller: viewModelRead.textEditingController,
          textAlign: TextAlign.right,
          autofocus: true,
          keyboardType: TextInputType.none,
          decoration: null,
          cursorColor: appColors.primary,
          style: TextStyle(fontSize: constraints.maxHeight / 5),
          maxLines: null,
          focusNode: viewModelRead.focusNode,
        );
      }),
    );

    final viewModelResult = context.watch<CalculatorViewModel>().result;
    final bool showResult =
        (isSimpleNumber(viewModelRead.textEditingController.text) ||
            viewModelResult.toString().contains(nanString) ||
            viewModelResult == double.infinity ||
            viewModelResult == double.negativeInfinity);
    final Widget result = showResult
        ? const SizedBox()
        : FittedBox(
            child: GestureDetector(
              onLongPress: () async => await copyTextToClipboard(
                  numberFormatter.format(viewModelResult)),
              child: Text(
                numberFormatter.format(viewModelResult),
                style: TextStyle(color: appColors.result),
              ),
            ),
          );

    final toogleScientificButton = ElevatedButton.icon(
      onPressed: viewModelRead.toogleScientific,
      icon: Icon(
        context.watch<CalculatorViewModel>().isScientific
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down,
      ),
      label: const Text('Scientific'),
      style: FilledButton.styleFrom(
        foregroundColor: isLightTheme ? Colors.black : Colors.white,
        iconColor: isLightTheme ? Colors.black : appColors.primary,
        backgroundColor: appColors.toogleScientificButtonBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        splashFactory: InkSplash.splashFactory,
      ),
    );

    late final angleButton = GridButton(
      onPressed: viewModelRead.toogleRadians,
      text: viewModelRead.radians ? 'RAD' : 'DEG',
      foregroundColor: appColors.toogleRadiansButtonForeground,
    );

    final backspaceButton = InkWell(
      onTap: viewModelRead.onPressBack,
      onLongPress: viewModelRead.onLongPressBack,
      child: Icon(
        Icons.backspace_rounded,
        size: 35,
        color: isLightTheme ? null : appColors.primary,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${viewModelRead.isScientific ? 'Scientific ' : ''}Calculator',
        ),
        actions: [unitConverterButton, historyButton],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: textField,
              ),
              Expanded(child: result),
              Expanded(
                child: Row(
                  children: [
                    toogleScientificButton,
                    const SizedBox(width: 8),
                    if (context
                        .watch<CalculatorViewModel>()
                        .hasTrigonometricFunction)
                      angleButton,
                    const Spacer(),
                    backspaceButton,
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                flex: context.watch<CalculatorViewModel>().isScientific ? 7 : 5,
                child: const CalculatorButtonGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
