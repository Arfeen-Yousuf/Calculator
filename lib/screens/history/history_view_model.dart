import 'package:calculator/services/history_database.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';

class HistoryViewModel extends ChangeNotifier {
  HistoryViewModel({
    required int totalHistoryLogs,
    required initialHistoryLogs,
  })  : _totalHistoryLogs = totalHistoryLogs,
        _historyLogs = initialHistoryLogs;

  ///Number of history logs in the device database
  int _totalHistoryLogs;
  int get totalHistoryLogs => _totalHistoryLogs;

  final List<HistoryLog> _historyLogs;
  List<HistoryLog> get historyLogs => List.unmodifiable(_historyLogs);

  void createHistoryLog(HistoryLog log) async {
    _totalHistoryLogs++;
    _historyLogs.insert(0, log);
    await HistoryDatabaseManager.insertHistoryLog(log);
    notifyListeners();
  }

  void deleteHistoryLog(HistoryLog log) async {
    _totalHistoryLogs--;
    _historyLogs.remove(log);
    await HistoryDatabaseManager.deleteHistoryLog(log);
    notifyListeners();
  }

  void addHistoryLogs(Iterable<HistoryLog> logs) {
    _historyLogs.addAll(logs);
    notifyListeners();
  }

  void clearHistoryLogs() async {
    if (_totalHistoryLogs == 0) return;
    _totalHistoryLogs = 0;
    _historyLogs.clear();
    await HistoryDatabaseManager.clearHistory();
    notifyListeners();
  }

  void loadMoreHistoryLogs() async {
    if (_historyLogs.length >= _totalHistoryLogs) return;
    final newFetchedLogs = await HistoryDatabaseManager.historyLogs(
      limit: Constants.historyLogsPerPage,
      offset: _historyLogs.length,
    );
    _historyLogs.addAll(newFetchedLogs);
    notifyListeners();
  }
}
