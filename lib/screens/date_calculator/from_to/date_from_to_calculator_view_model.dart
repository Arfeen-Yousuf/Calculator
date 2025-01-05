import 'package:flutter/material.dart';

class DateFromToCalculatorViewModel extends ChangeNotifier {
  DateFromToCalculatorViewModel() {
    durationFocusNode.addListener(notifyListeners);
  }

  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  void onStartDateChanged(DateTime? date) {
    _startDate = date;
    notifyListeners();
  }

  final durationController = TextEditingController();
  final durationFocusNode = FocusNode();

  int? _duration;
  void onDurationChanged(int? duration) {
    _duration = duration;
    notifyListeners();
  }

  DateTime? get endDate {
    if (_startDate == null || _duration == null) {
      return null;
    }

    return _startDate!.add(Duration(days: _duration!));
  }
}
