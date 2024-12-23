import 'dart:developer';

import 'package:calculator/app/colors.dart';
import 'package:calculator/enums/history_log_action.dart';
import 'package:calculator/screens/history/history_view_model.dart';
import 'package:calculator/services/history_database.dart';
import 'package:calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryLogTile extends StatelessWidget {
  const HistoryLogTile({
    super.key,
    required this.historyLog,
  });

  final HistoryLog historyLog;

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;

    return ListTile(
      title: Text(
        historyLog.expression,
        textAlign: TextAlign.end,
      ),
      subtitle: Text(
        '= ${historyLog.result}',
        textAlign: TextAlign.end,
      ),
      subtitleTextStyle: TextTheme.of(context)
          .titleMedium
          ?.copyWith(color: appColors.historyTileResult),
      trailing: Icon(Icons.chevron_right),
      onTap: () => showHistoryLogOptions(context),
    );
  }

  void showHistoryLogOptions(BuildContext context) async {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;

    final replaceButton = ListTile(
      title: Text('Replace'),
      leading: Icon(Icons.swap_horiz_outlined),
      contentPadding: EdgeInsets.zero,
      onTap: () => Navigator.of(context).pop<(HistoryLogAction, HistoryLog)>(
        (
          HistoryLogAction.replace,
          historyLog,
        ),
      ),
    );
    final copyResultButton = ListTile(
      title: Text('Copy result'),
      leading: Icon(Icons.copy),
      contentPadding: EdgeInsets.zero,
      onTap: () async {
        await Clipboard.setData(
          ClipboardData(
            text:
                'Expression:\n${historyLog.expression}\nResult:\n${historyLog.result}',
          ),
        );
        showToast('Expression and result copied.');
      },
    );
    final deleteButton = ListTile(
      title: Text('Delete'),
      leading: Icon(Icons.delete_outline),
      contentPadding: EdgeInsets.zero,
      onTap: () async {
        context.read<HistoryViewModel>().deleteHistoryLog(historyLog);
        Navigator.pop(context);
      },
    );

    final modalOutput =
        await showModalBottomSheet<(HistoryLogAction, HistoryLog)?>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: appColors.scaffoldBackground,
                borderRadius: BorderRadiusDirectional.only(
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
                      Text(
                        DateFormat('HH:mm, MMM dd, yyyy')
                            .format(historyLog.dateTime),
                        style: TextTheme.of(context)
                            .labelLarge
                            ?.copyWith(fontSize: 20),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: isLightTheme ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          historyLog.expression,
                          style: TextTheme.of(context).titleLarge,
                        ),
                        Text(
                          historyLog.result,
                          style: TextTheme.of(context).titleLarge?.copyWith(
                                color: appColors.primary,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      replaceButton,
                      copyResultButton,
                      deleteButton,
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    log('HistoryLog in tile $modalOutput');
    if (modalOutput != null && context.mounted) {
      log('HistoryLog in tile popped');
      Navigator.of(context).pop<(HistoryLogAction, HistoryLog)>(modalOutput);
    }
  }
}
