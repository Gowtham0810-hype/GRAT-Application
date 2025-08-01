import 'package:flutter/material.dart';

class OHISData extends ChangeNotifier {
  // Tooth numbers for DI-S and CI-S
  final List<String> diSTeeth = ['16', '11', '26', '36', '31', '46'];
  final List<String> ciSTeeth = ['16', '11', '26', '36', '31', '46'];

  // Maps to store values for DI-S and CI-S
  final Map<String, String> _diSValues = {};
  final Map<String, String> _ciSValues = {};

  OHISData() {
    initializeValues();
  }

  void initializeValues() {
    for (String tooth in diSTeeth) {
      _diSValues[tooth] = '0';
      _ciSValues[tooth] = '0';
    }
  }

  // DI-S methods
  String getDISValue(String toothNum) => _diSValues[toothNum] ?? '0';
  void setDISValue(String toothNum, String value) {
    if (value == '0' || value == '1' || value == '2' || value == '3') {
      _diSValues[toothNum] = value;
      notifyListeners();
    }
  }

  // CI-S methods
  String getCISValue(String toothNum) => _ciSValues[toothNum] ?? '0';
  void setCISValue(String toothNum, String value) {
    if (value == '0' || value == '1' || value == '2' || value == '3') {
      _ciSValues[toothNum] = value;
      notifyListeners();
    }
  }

  // Calculate DI-S score (average of all DI-S values)
  double calculateDISScore() {
    double sum = 0;
    int count = 0;
    _diSValues.forEach((tooth, value) {
      sum += int.parse(value);
      count++;
    });
    return count > 0 ? sum / count : 0;
  }
  
  void updateFromMap(Map<String, dynamic> data) {
  // Reset all values to '0'
  initializeValues();
  
  try {
    // Update DI-S values
    if (data['debrisIndex']?['individualScores'] is Map) {
      final diScores = data['debrisIndex']['individualScores'] as Map<String, dynamic>;
      diScores.forEach((tooth, value) {
        if (_diSValues.containsKey(tooth) && value is String) {
          _diSValues[tooth] = value;
        }
      });
    }
    
    // Update CI-S values
    if (data['calculusIndex']?['individualScores'] is Map) {
      final ciScores = data['calculusIndex']['individualScores'] as Map<String, dynamic>;
      ciScores.forEach((tooth, value) {
        if (_ciSValues.containsKey(tooth) && value is String) {
          _ciSValues[tooth] = value;
        }
      });
    }
    
    notifyListeners();
  } catch (e) {
    debugPrint('Error restoring OHI-S values: $e');
    // If error occurs, maintain initialized values
  }
}
  // Calculate CI-S score (average of all CI-S values)
  double calculateCISScore() {
    double sum = 0;
    int count = 0;
    _ciSValues.forEach((tooth, value) {
      sum += int.parse(value);
      count++;
    });
    return count > 0 ? sum / count : 0;
  }

  // Calculate overall OHI-S score
  double calculateOHISScore() {
    return calculateDISScore() + calculateCISScore();
  }

  // Get risk level based on OHI-S score
  String getRiskLevel() {
    final score = calculateOHISScore();
    if (score <= 1.2) return 'Low Risk';
    if (score <= 3.0) return 'Moderate Risk';
    return 'High Risk';
  }
}