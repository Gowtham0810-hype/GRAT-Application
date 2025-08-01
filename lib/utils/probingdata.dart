import 'package:flutter/material.dart';

class PeriodontalProbingProvider extends ChangeNotifier {
  // Probing data for upper and lower teeth
  final List<String> upperTeeth = ['18', '17', '16', '15', '14', '13', '12', '11', '21', '22', '23', '24', '25', '26', '27', '28'];
  final List<String> lowerTeeth = ['48', '47', '46', '45', '44', '43', '42', '41', '31', '32', '33', '34', '35', '36', '37', '38'];
  
  final Map<String, bool> _probingValues = {};
  int _missingTeeth = 0;
  int _recessionTeeth = 0;
  final Set<String> _toothFactors = {};

  PeriodontalProbingProvider() {
    initializeValues();
  }

  void initializeValues() {
    for (String tooth in upperTeeth) {
      _probingValues[tooth] = false;
    }
    for (String tooth in lowerTeeth) {
      _probingValues[tooth] = false;
    }
  }

  // Probing methods
  bool getProbingValue(String toothNum) => _probingValues[toothNum] ?? false;
  
  void toggleProbingValue(String toothNum) {
    _probingValues[toothNum] = !(_probingValues[toothNum] ?? false);
    notifyListeners();
  }

  int get teethWithProbingDepth => 
      _probingValues.values.where((value) => value).length;

  // Missing teeth methods
  int get missingTeeth => _missingTeeth;
  set missingTeeth(int value) {
    _missingTeeth = value;
    notifyListeners();
  }

  // Recession teeth methods
  int get recessionTeeth => _recessionTeeth;
  set recessionTeeth(int value) {
    _recessionTeeth = value;
    notifyListeners();
  }


  void updateFromMap(Map<String, dynamic> data) {
  try {
    // Reset all values first
    initializeValues();
    _missingTeeth = 0;
    _recessionTeeth = 0;
    _toothFactors.clear();

    // Update probing values
    if (data['probingStatus'] is Map) {
      final probingStatus = data['probingStatus'] as Map<String, dynamic>;
      
      // Upper teeth
      if (probingStatus['upperTeeth'] is Map) {
        final upperTeethStatus = probingStatus['upperTeeth'] as Map<String, dynamic>;
        upperTeethStatus.forEach((tooth, value) {
          if (_probingValues.containsKey(tooth) && value is bool) {
            _probingValues[tooth] = value;
          }
        });
      }
      
      // Lower teeth
      if (probingStatus['lowerTeeth'] is Map) {
        final lowerTeethStatus = probingStatus['lowerTeeth'] as Map<String, dynamic>;
        lowerTeethStatus.forEach((tooth, value) {
          if (_probingValues.containsKey(tooth) && value is bool) {
            _probingValues[tooth] = value;
          }
        });
      }
    }

    // Update missing teeth count
    if (data['missingTeethCount'] is int) {
      _missingTeeth = data['missingTeethCount'];
    }

    // Update recession teeth count
    if (data['teethWithRecession'] is int) {
      _recessionTeeth = data['teethWithRecession'];
    }

    // Update identified risk factors
    if (data['identifiedRiskFactors'] is List) {
      _toothFactors.addAll(
        (data['identifiedRiskFactors'] as List).whereType<String>()
      );
    }

    notifyListeners();
  } catch (e) {
    debugPrint('Error restoring periodontal probing data: $e');
    // If error occurs, maintain initialized values
  }
}

  // Tooth factors methods
  Set<String> get toothFactors => _toothFactors;
  
  void toggleToothFactor(String factor) {
    if (_toothFactors.contains(factor)) {
      _toothFactors.remove(factor);
    } else {
      _toothFactors.add(factor);
    }
    notifyListeners();
  }

  bool hasToothFactor(String factor) => _toothFactors.contains(factor);
}