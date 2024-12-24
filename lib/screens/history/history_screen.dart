import 'package:calculator/app/colors.dart';
import 'package:calculator/screens/history/history_view_model.dart';
import 'package:calculator/utils/utils.dart';
import 'package:calculator/widgets/date_text.dart';
import 'package:calculator/widgets/history_log_tile.dart';
import 'package:calculator/widgets/primary_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HistoryViewModel>();
    final historyLogs = viewModel.historyLogs;
    final logsCount = historyLogs.length;

    final deleteHistoryButton = IconButton(
      onPressed: () => showClearHistoryAlertDialog(context),
      icon: const Icon(Icons.delete_outlined),
    );
    late final loadMoreButton = PrimaryTextFilledButton(
      onPressed: context.read<HistoryViewModel>().loadMoreHistoryLogs,
      text: 'Load More',
    );

    final dateTextStyle = TextTheme.of(context).titleLarge;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [deleteHistoryButton],
      ),
      body: SafeArea(
        child: (historyLogs.isEmpty)
            ? Center(
                child: Text(
                  'No logs',
                  style:
                      TextTheme.of(context).bodyLarge?.copyWith(fontSize: 30),
                ),
              )
            : ListView.separated(
                itemCount: (viewModel.totalHistoryLogs == logsCount)
                    ? logsCount
                    : logsCount + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        DateText(
                          dateTime: historyLogs[index].dateTime,
                          style: dateTextStyle,
                        ),
                        HistoryLogTile(historyLog: historyLogs[index]),
                      ],
                    );
                  } else if (index == logsCount) {
                    return loadMoreButton;
                  }

                  return HistoryLogTile(historyLog: historyLogs[index]);
                },
                padding: const EdgeInsets.all(8),
                separatorBuilder: (_, ind) {
                  if (ind >= logsCount - 1) {
                    return Container();
                  }

                  final dateTime1 = truncateDateTime(historyLogs[ind].dateTime);
                  final dateTime2 =
                      truncateDateTime(historyLogs[ind + 1].dateTime);

                  if (dateTime2.isBefore(dateTime1)) {
                    return Column(
                      children: [
                        const Divider(),
                        DateText(
                          dateTime: dateTime2,
                          style: dateTextStyle,
                        ),
                      ],
                    );
                  }

                  return const Divider();
                },
              ),
      ),
    );
  }

  void showClearHistoryAlertDialog(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Delete history'),
          content: const Text('All history will be deleted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Dismiss'),
            ),
            TextButton(
              onPressed: () {
                context.read<HistoryViewModel>().clearHistoryLogs();
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
          ],
          backgroundColor:
              isLightTheme ? AppColorsLight.scaffoldBackground : null,
        );
      },
    );
  }
}
