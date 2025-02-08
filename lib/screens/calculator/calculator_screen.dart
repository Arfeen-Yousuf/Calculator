import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:calculator/app/colors.dart';
import 'package:calculator/providers/settings_provider.dart';
//import 'package:calculator/utils/constants.dart';
import 'package:calculator/utils/utils.dart';
import 'package:calculator/widgets/grid_button.dart';
import 'package:calculator/widgets/my_drawer.dart';
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

    final textField = AutoSizeTextField(
      controller: viewModelRead.textEditingController,
      textAlign: TextAlign.right,
      autofocus: true,
      keyboardType: TextInputType.none,
      decoration: const InputDecoration(border: InputBorder.none),
      cursorColor: appColors.primary,
      style: const TextStyle(
        fontSize: 50,
      ),
      minFontSize: 30,
      focusNode: viewModelRead.focusNode,
    );

    final viewModelResult = context.watch<CalculatorViewModel>().result;
    final viewModelError = context.watch<CalculatorViewModel>().error;
    final isCalculating = context.watch<CalculatorViewModel>().isCalculating;

    final Widget resultOrError;

    if (isCalculating) {
      resultOrError = FittedBox(
        child: Text(
          'Calculating',
          style: TextStyle(color: appColors.result),
        ),
      );
    } else if (viewModelError != null ||
        viewModelResult == null ||
        isSimpleNumber(viewModelRead.textEditingController.text)) {
      resultOrError = const SizedBox();
    } else {
      final formattedResult = isCalculating
          ? 'Calculating'
          : formatDecimal(
              viewModelResult,
              decimalPlaces: context.read<SettingsProvider>().decimalPlaces,
            );

      resultOrError = FittedBox(
        child: GestureDetector(
          onLongPress: () async => await copyTextToClipboard(
            formattedResult,
          ),
          child: Text(
            formattedResult,
            style: TextStyle(color: appColors.result),
          ),
        ),
      );
    }

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
      onPressed: viewModelRead.toogleAngleInDegree,
      text: viewModelRead.angleInDegree ? 'RAD' : 'DEG',
      foregroundColor: appColors.primary,
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

    final scaffold = Scaffold(
      appBar: AppBar(
        title: Text(
          '${viewModelRead.isScientific ? 'Scientific ' : ''}Calculator',
        ),
        actions: [historyButton],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: textField,
                ),
              ),
              Expanded(child: resultOrError),
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
      drawer: const MyDrawer(),
    );

    return PopScope(
      canPop: !context.read<SettingsProvider>().keepLastRecord ||
          context.watch<CalculatorViewModel>().canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        showToast("Press 'Back' once more to exit");
        await viewModelRead.saveExpression();
      },
      child: scaffold,
    );
  }
}
