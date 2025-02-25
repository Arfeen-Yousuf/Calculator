import 'package:flutter/material.dart';

class DateDurationCalculatorViewModel extends ChangeNotifier {
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  void onStartDateChanged(DateTime? date) {
    _startDate = date;
    notifyListeners();
  }

  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  void onEndDateChanged(DateTime? date) {
    _endDate = date;
    notifyListeners();
  }

  int? get duration {
    if (_startDate == null || _endDate == null) {
      return null;
    }

    return _endDate!.difference(_startDate!).inDays;
  }
}
