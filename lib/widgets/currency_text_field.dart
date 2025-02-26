import 'package:calculator/app/colors.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';

import 'number_text_field.dart';

class CurrencyTextField extends StatelessWidget {
  const CurrencyTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.title,
    this.hintText,
    required this.currency,
    required this.onCurrencySelected,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? title;
  final String? hintText;
  final Currency currency;

  final void Function(Currency currency) onCurrencySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton.tonalIcon(
          onPressed: () => _showCurrencyPicker(context),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
          ),
          label: Text.rich(
            TextSpan(
              text:
                  '${CurrencyUtils.currencyToEmoji(currency)} ${currency.code} ',
              style: TextTheme.of(context).labelMedium?.copyWith(fontSize: 18),
              children: [
                TextSpan(
                  text: '(${currency.name})',
                  style: TextTheme.of(context).labelSmall?.copyWith(
                        fontSize: 15,
                        color: Colors.grey[500],
                      ),
                )
              ],
            ),
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            size: 30,
          ),
          iconAlignment: IconAlignment.end,
        ),
        NumberTextField(
          controller: controller,
          focusNode: focusNode,
          hintText: hintText,
        ),
      ],
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    showCurrencyPicker(
        context: context,
        theme: CurrencyPickerThemeData(
          flagSize: 25,
          titleTextStyle: const TextStyle(fontSize: 17),
          subtitleTextStyle:
              TextStyle(fontSize: 15, color: Theme.of(context).hintColor),
          bottomSheetHeight: MediaQuery.of(context).size.height * 0.8,
          //Optional. Styles the search field.
          inputDecoration: InputDecoration(
            hintText: 'Start typing to search',
            prefixIcon: const Icon(Icons.search),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: appColors.primary ?? Colors.black,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: appColors.primary ?? Colors.black,
              ),
            ),
          ),
        ),
        onSelect: (currency) => onCurrencySelected(currency),
        favorite: ['PKR', 'USD']);
  }
}
