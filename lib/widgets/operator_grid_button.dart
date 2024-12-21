import 'package:calculator/utils/colors.dart';

import 'grid_button.dart';

class OperatorGridButton extends GridButton {
  OperatorGridButton({
    super.key,
    super.onPressed,
    required super.text,
  }) : super(
          foregroundColor: AppColors.primary,
          backgroundColor: AppColors.primary.withAlpha(25),
          largeFontSize: true,
        );
}
