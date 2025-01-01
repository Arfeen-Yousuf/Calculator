import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

Future<int?> showOptionsBottomSheet(
  BuildContext context, {
  String? title,
  Map<String, Widget?>? leading,
  required List<String> options,
  String? currentOption,
  required void Function(int index) onOptionSelected,
}) {
  final isLightTheme = Theme.of(context).brightness == Brightness.light;
  final AppColors appColors = Theme.of(context).extension<AppColors>()!;

  return showModalBottomSheet<int?>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight * 0.7,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: appColors.scaffoldBackground,
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(20),
              topEnd: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: TextTheme.of(context)
                          .labelLarge
                          ?.copyWith(fontSize: 20),
                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: isLightTheme ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.separated(
                    itemCount: options.length,
                    itemBuilder: (_, index) {
                      final String option = options[index];
                      final textStyle =
                          TextTheme.of(context).titleMedium?.copyWith(
                                color: (currentOption == option)
                                    ? appColors.primary
                                    : appColors.primaryText,
                                fontSize: 16,
                              );

                      return ListTile(
                        leading: leading?[option],
                        title: Text(option),
                        selected: (currentOption == option),
                        selectedColor: appColors.primary,
                        titleTextStyle: textStyle,
                        onTap: () {
                          onOptionSelected(index);
                          Navigator.pop(context, index);
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}
