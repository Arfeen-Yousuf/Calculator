import 'dart:math';

import 'package:calculator/app/colors.dart';
import 'package:calculator/widgets/bottom_sheet_header.dart';
import 'package:calculator/widgets/outlined_text_filled_button.dart';
import 'package:calculator/widgets/primary_filled_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<int?> showOptionsBottomSheet<T>(
  BuildContext context, {
  String? title,
  Map<T, Widget?>? leading,
  required List<T> options,
  T? currentOption,
  required void Function(int index) onOptionSelected,
}) {
  final appColors = Theme.of(context).extension<AppColors>()!;

  return showModalBottomSheet<int?>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: min(50 + options.length * 66, constraints.maxHeight * 0.7),
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
                BottomSheetHeader(title: title),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.separated(
                      itemCount: options.length,
                      itemBuilder: (_, index) {
                        final T option = options[index];
                        final textStyle =
                            TextTheme.of(context).titleMedium?.copyWith(
                                  color: (currentOption == option)
                                      ? appColors.primary
                                      : appColors.primaryText,
                                  fontSize: 16,
                                );

                        return ListTile(
                          leading: leading?[option],
                          title: Text('$option'),
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
        }),
      );
    },
  );
}

///Looks for [initialIndex] before [initialValue]
Future<int?> showValuePicker<T>(
  BuildContext context, {
  String? title,
  required List<T> values,
  int? initialIndex,
  T? initialValue,
}) async {
  final appColors = Theme.of(context).extension<AppColors>()!;

  int selectedIndex = 0;
  if (initialIndex != null) {
    selectedIndex = initialIndex;
  } else if (initialValue != null) {
    selectedIndex = values.indexOf(initialValue);
  }

  final int? pickedIndex = await showCupertinoModalPopup<int>(
    context: context,
    builder: (_) => SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appColors.scaffoldBackground,
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(20),
            topEnd: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BottomSheetHeader(title: title),
            SizedBox(
              height: 250,
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: selectedIndex),
                itemExtent: 40, // Height of each item
                onSelectedItemChanged: (index) => selectedIndex = index,
                children: List.generate(
                  values.length,
                  (index) => FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text('${values[index]}'),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedTextFilledButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: PrimaryTextFilledButton(
                    text: 'Done',
                    onPressed: () => Navigator.pop<int>(context, selectedIndex),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  return pickedIndex;
}
