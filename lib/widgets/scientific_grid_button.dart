import 'package:calculator/utils/colors.dart';

import 'grid_button.dart';

class ScientificGridButton extends GridButton {
  const ScientificGridButton({
    super.key,
    super.onPressed,
    required super.text,
  }) : super(
          backgroundColor: AppColors.gridScientificButtonBackground,
        );
}
