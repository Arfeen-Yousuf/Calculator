import 'dart:developer';

import 'package:sqflite/sqflite.dart';

const String tableHistory = 'history';
const String columnId = '_id';
const String columnDateTime = '_dateTime';
const String columnExpression = 'expression';
const String columnResult = 'result';

class HistoryLog {
  int? id;
  late DateTime dateTime;
  String expression;
  num result;

  HistoryLog({
    this.id,
    DateTime? dateTime,
    required this.expression,
    required this.result,
  }) {
    this.dateTime = dateTime ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      columnDateTime: '$dateTime',
      columnExpression: expression,
      columnResult: result,
    };
    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }

  factory HistoryLog.fromMap(Map<String, dynamic> map) {
    return HistoryLog(
      id: map[columnId] as int,
      dateTime: DateTime.parse(map[columnDateTime] as String),
      expression: map[columnExpression] as String,
      result: map[columnResult] as num,
    );
  }

  @override
  bool operator ==(Object other) => (other is HistoryLog && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => toMap().toString();
}

class HistoryDatabaseManager {
  static late Database db;

  ///Retrieves the number of history logs
  static Future<int> historyLogsCount() async {
    final logsKeys = await db.query(
      tableHistory,
      columns: [columnId],
    );
    return logsKeys.length;
  }

  ///Retrieves history logs from the history table.
  static Future<List<HistoryLog>> historyLogs({
    int? limit,
    int? offset,
  }) async {
    final List<Map<String, Object?>> logsMaps = await db.query(
      tableHistory,
      limit: limit,
      offset: offset,
      orderBy: '$columnId DESC',
    );
    return logsMaps.map((map) => HistoryLog.fromMap(map)).toList();
  }

  ///Inserts a history log into the history table
  static Future<HistoryLog> insertHistoryLog(HistoryLog historyLog) async {
    historyLog.id = await db.insert(tableHistory, historyLog.toMap());
    log('$historyLog inserted');
    return historyLog;
  }

  ///Retrieves a history log with the specified id
  static Future<HistoryLog?> getHistoryLog({required int id}) async {
    List<Map<String, Object?>> maps = await db.query(
      tableHistory,
      columns: [columnId, columnDateTime, columnResult, columnExpression],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return HistoryLog.fromMap(maps.first);
    }

    return null;
  }

  ///Deletes a history log with the specified id
  static Future<int> deleteHistoryLog(HistoryLog historyLog) async {
    return await db.delete(
      tableHistory,
      where: '$columnId = ?',
      whereArgs: [historyLog.id],
    );
  }

  ///Deletes all history logs
  static Future<void> clearHistory() async {
    await db.delete(tableHistory);
  }

  ///Updates a history log
  Future<int> updateHistory(HistoryLog historyLog) async {
    return await db.update(
      tableHistory,
      historyLog.toMap(),
      where: '$columnId = ?',
      whereArgs: [historyLog.id],
    );
  }

  ///Closes the database
  static Future close() async => db.close();
}
