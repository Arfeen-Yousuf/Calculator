import 'package:calculator/utils/colors.dart';
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

    final historyButton = IconButton(
      onPressed: () {},
      icon: Icon(Icons.history_rounded),
    );

    final textField = Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: LayoutBuilder(builder: (context, constraints) {
        return TextField(
          controller: context.read<CalculatorViewModel>().textEditingController,
          textAlign: TextAlign.right,
          autofocus: true,
          keyboardType: TextInputType.none,
          decoration: null,
          cursorColor: AppColors.primary,
          style: TextStyle(fontSize: constraints.maxHeight / 5),
          maxLines: null,
          focusNode: context.read<CalculatorViewModel>().focusNode,
        );
      }),
    );
    final Widget result =
        (context.watch<CalculatorViewModel>().textEditingController.text ==
                context.watch<CalculatorViewModel>().result)
            ? SizedBox()
            : FittedBox(
                child: Text(
                  context.watch<CalculatorViewModel>().result,
                  style: TextStyle(color: AppColors.result),
                ),
              );

    final toogleScientificButton = ElevatedButton.icon(
      onPressed: context.read<CalculatorViewModel>().toogleScientific,
      icon: Icon(
        context.read<CalculatorViewModel>().isScientific
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down,
      ),
      label: Text('Scientific'),
      style: FilledButton.styleFrom(
        foregroundColor: isLightTheme ? Colors.black : Colors.white,
        iconColor: isLightTheme ? Colors.black : AppColors.primary,
        backgroundColor: AppColors.toogleScientificButtonBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    late final angleButton = GridButton(
      onPressed: context.read<CalculatorViewModel>().toogleRadians,
      text: context.read<CalculatorViewModel>().radians ? 'RAD' : 'DEG',
      foregroundColor: AppColors.toogleRadiansButtonForeground,
    );

    final backspaceButton = InkWell(
      onTap: context.read<CalculatorViewModel>().onPressBack,
      onLongPress: context.read<CalculatorViewModel>().onLongPressBack,
      child: Icon(
        Icons.backspace_rounded,
        size: 35,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [historyButton],
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
                    SizedBox(width: 8),
                    if (context
                        .read<CalculatorViewModel>()
                        .hasTrigonometricFunction)
                      angleButton,
                    Spacer(),
                    backspaceButton,
                  ],
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                flex: context.read<CalculatorViewModel>().isScientific ? 7 : 5,
                child: const CalculatorButtonGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
