import 'dart:developer';

import 'package:flutter/material.dart';

class DiscountCalculatorViewModel extends ChangeNotifier {
  DiscountCalculatorViewModel() {
    _focusNodes = [taxFocusNode, priceFocusNode, discountFocusNode];
    _textEditingControllers = [
      taxTextEditingController,
      priceTextEditingController,
      discountTextEditingController
    ];
    for (var node in _focusNodes) {
      node.addListener(_onFocusNodeChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in _textEditingControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  TextEditingController? _currentController;
  TextEditingController? get currentController => _currentController;

  FocusNode? _currentFocusNode;
  FocusNode? get currentFocusNode => _currentFocusNode;
  bool get isPercentageFocusNode =>
      [taxFocusNode, discountFocusNode].contains(_currentFocusNode);

  final taxTextEditingController = TextEditingController();
  final taxFocusNode = FocusNode();

  final priceTextEditingController = TextEditingController();
  final priceFocusNode = FocusNode();

  final discountTextEditingController = TextEditingController();
  final discountFocusNode = FocusNode();

  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _textEditingControllers;

  double? _taxPercentage;
  double? _originalPrice;
  double? _discountPercentage;

  List<MapEntry<String, double?>> get results {
    double originalPrice = _originalPrice ?? 0;
    double discountPercentage = _discountPercentage ?? 0;
    double taxPercentage = _taxPercentage ?? 0;

    double savedAmount = originalPrice * (discountPercentage / 100);
    double discountedPrice = originalPrice - savedAmount;
    double tax = discountedPrice * (taxPercentage / 100);
    double finalPrice = discountedPrice + tax;

    return [
      MapEntry('Amount Saved', savedAmount),
      MapEntry('Tax', tax),
      MapEntry('Final Price', finalPrice),
    ];
  }

  void onValueChanged(double? value) {
    if (_currentFocusNode == null) {
      return;
    } else if (_currentFocusNode == taxFocusNode) {
      log('Discount Calculator: Tax $value');
      _taxPercentage = value;
    } else if (_currentFocusNode == priceFocusNode) {
      log('Discount Calculator: Price $value');
      _originalPrice = value;
    } else if (_currentFocusNode == discountFocusNode) {
      log('Discount Calculator: Discount $value');
      _discountPercentage = value;
    }

    notifyListeners();
  }

  void clearAll() {
    for (final controller in _textEditingControllers) {
      controller.clear();
    }

    _taxPercentage = null;
    _originalPrice = null;
    _discountPercentage = null;

    notifyListeners();
  }

  void _onFocusNodeChanged() {
    final focusedNodeIndex = _focusNodes.indexWhere((node) => node.hasFocus);
    if (focusedNodeIndex == -1) {
      _currentController = null;
      _currentFocusNode = null;
    } else {
      _currentController = _textEditingControllers[focusedNodeIndex];
      _currentFocusNode = _focusNodes[focusedNodeIndex];
    }

    notifyListeners();
  }
}
