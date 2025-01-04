import 'dart:developer';

import 'package:flutter/material.dart';

class DateCalculatorViewModel extends ChangeNotifier {
  DateCalculatorViewModel() {
    durationFocusNode.addListener(() => notifyListeners());
  }

  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  void onStartDateChanged(DateTime? date) {
    _startDate = date;
    log('View model new From Date $date');
    notifyListeners();
  }

  final durationController = TextEditingController();
  final durationFocusNode = FocusNode();

  int? _duration;
  void onDurationChanged(int? duration) {
    _duration = duration;
    log('View model new Duration $duration');
    notifyListeners();
  }

  DateTime? get endDate {
    if (_startDate == null || _duration == null) {
      return null;
    }

    return _startDate!.add(Duration(days: _duration!));
  }
}
