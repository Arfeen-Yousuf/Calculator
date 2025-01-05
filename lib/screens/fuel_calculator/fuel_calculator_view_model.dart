import 'package:flutter/material.dart';
import 'package:units_converter/units_converter.dart';

enum FuelEfficiency {
  kilometersPerLiter(LENGTH.kilometers, VOLUME.liters),
  milesPerLiter(LENGTH.miles, VOLUME.liters),
  kilometersPerUsGallons(LENGTH.kilometers, VOLUME.usGallons),
  milesPerUsGallons(LENGTH.miles, VOLUME.usGallons),
  kilometersPerImperialGallons(LENGTH.kilometers, VOLUME.imperialGallons),
  milesPerImperialGallons(LENGTH.miles, VOLUME.imperialGallons);

  const FuelEfficiency(this.lengthUnit, this.volumeUnit);

  final LENGTH lengthUnit;
  final VOLUME volumeUnit;

  double toKilometersPerLiter(double efficiency) {
    if (this == FuelEfficiency.kilometersPerLiter) {
      return efficiency;
    }

    final lengthInKms = 1.convertFromTo(lengthUnit, LENGTH.kilometers)!;
    final volumeInLiters = 1.convertFromTo(volumeUnit, VOLUME.liters)!;
    return efficiency * (lengthInKms / volumeInLiters);
  }

  @override
  String toString() {
    return switch (this) {
      FuelEfficiency.kilometersPerLiter => 'km/l',
      FuelEfficiency.milesPerLiter => 'mi/l',
      FuelEfficiency.kilometersPerUsGallons => 'km/gal(US)',
      FuelEfficiency.milesPerUsGallons => 'mi/gal(US)',
      FuelEfficiency.kilometersPerImperialGallons => 'km/gal(UK)',
      FuelEfficiency.milesPerImperialGallons => 'mi/gal(UK)'
    };
  }
}

class FuelCalculatorViewModel extends ChangeNotifier {
  FuelCalculatorViewModel() {
    _focusNodes = [distanceFocusNode, priceFocusNode, efficiencyFocusNode];
    _textEditingControllers = [
      distanceTextEditingController,
      priceTextEditingController,
      efficiencyTextEditingController
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

  final distanceTextEditingController = TextEditingController();
  final distanceFocusNode = FocusNode();

  final efficiencyTextEditingController = TextEditingController();
  final efficiencyFocusNode = FocusNode();

  final priceTextEditingController = TextEditingController();
  final priceFocusNode = FocusNode();

  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _textEditingControllers;

  double? _distance;
  LENGTH _distanceUnit = LENGTH.kilometers;
  LENGTH get distanceUnit => _distanceUnit;
  void onDistanceUnitChanged(LENGTH unit) {
    _distanceUnit = unit;
    notifyListeners();
  }

  double? _efficiency;
  FuelEfficiency _efficiencyUnit = FuelEfficiency.kilometersPerLiter;
  FuelEfficiency get efficiencyUnit => _efficiencyUnit;
  void onFuelEfficiencyUnitChanged(FuelEfficiency unit) {
    _efficiencyUnit = unit;
    notifyListeners();
  }

  double? _price;
  VOLUME _priceVolumeUnit = VOLUME.liters;
  VOLUME get priceVolumeUnit => _priceVolumeUnit;
  void onPriceVolumeUnitChanged(VOLUME unit) {
    _priceVolumeUnit = unit;
    notifyListeners();
  }

  List<MapEntry<String, double?>> get results {
    if (_distance == null || _efficiency == null || _price == null) {
      return [
        const MapEntry('Cost of fuel', null),
        const MapEntry('Amount of fuel', null),
      ];
    }

    double distance =
        _distance!.convertFromTo(_distanceUnit, LENGTH.kilometers)!;
    double efficiency = _efficiencyUnit.toKilometersPerLiter(_efficiency!);
    double price = _price! / 1.convertFromTo(_priceVolumeUnit, VOLUME.liters)!;

    double fuelNeeded = distance / efficiency;
    double fuelCost = fuelNeeded * price;

    final String fuelUnit = switch (_priceVolumeUnit) {
      VOLUME.liters => 'liters',
      VOLUME.usGallons => 'galllons(US)',
      VOLUME.imperialGallons => 'gallons(UK)',
      _ => '',
    };
    return [
      MapEntry('Cost of fuel', fuelCost),
      MapEntry(
        'Amount of fuel in \n$fuelUnit',
        fuelNeeded.convertFromTo(VOLUME.liters, _priceVolumeUnit),
      ),
    ];
  }

  void onValueChanged(double? value) {
    if (_currentFocusNode == null) {
      return;
    } else if (_currentFocusNode == distanceFocusNode) {
      _distance = value;
    } else if (_currentFocusNode == priceFocusNode) {
      _price = value;
    } else if (_currentFocusNode == efficiencyFocusNode) {
      _efficiency = value;
    }

    notifyListeners();
  }

  void clearAll() {
    for (final controller in _textEditingControllers) {
      controller.clear();
    }

    _distance = null;
    _price = null;
    _efficiency = null;

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
