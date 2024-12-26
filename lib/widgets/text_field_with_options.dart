import 'package:calculator/app/colors.dart';
import 'package:flutter/material.dart';

class TextFieldWithOptions extends StatefulWidget {
  const TextFieldWithOptions({
    super.key,
    this.controller,
    this.focusNode,
    this.title,
    required this.options,
    this.onOptionSelected,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? title;
  final List<String> options;
  final void Function(int index)? onOptionSelected;

  @override
  State<TextFieldWithOptions> createState() => _TextFieldWithOptionsState();
}

class _TextFieldWithOptionsState extends State<TextFieldWithOptions> {
  late String currentOption;

  @override
  void initState() {
    super.initState();
    currentOption = widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton.tonalIcon(
          onPressed: () => _showOptionsBottomModalSheet(context),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
          ),
          label: Text(
            currentOption,
            style: TextTheme.of(context).labelMedium?.copyWith(fontSize: 20),
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            size: 30,
          ),
          iconAlignment: IconAlignment.end,
        ),
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.none,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: appColors.primary ?? Colors.black,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showOptionsBottomModalSheet(BuildContext context) async {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;

    final int? selectedOptionIndex = await showModalBottomSheet<int?>(
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
                    if (widget.title != null)
                      Text(
                        widget.title!,
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
                  child: ListView.separated(
                    itemCount: widget.options.length,
                    itemBuilder: (_, index) {
                      final String option = widget.options[index];
                      final textStyle =
                          TextTheme.of(context).labelMedium?.copyWith(
                                color: (currentOption == option)
                                    ? appColors.primary
                                    : appColors.primaryText,
                                fontSize: 16,
                              );

                      return FilledButton.tonal(
                        onPressed: () {
                          widget.onOptionSelected?.call(index);
                          Navigator.pop(context, index);
                        },
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Text(
                              option,
                              style: textStyle,
                              textAlign: TextAlign.left,
                            ),
                            const Spacer(),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );

    if (selectedOptionIndex != null) {
      setState(() {
        currentOption = widget.options[selectedOptionIndex];
      });
    }
  }
}
