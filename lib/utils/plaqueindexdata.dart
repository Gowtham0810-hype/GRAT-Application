import 'package:flutter/material.dart';
// Define the tooth numbers for upper and lower arches

class PlaqueIndexData extends ChangeNotifier {
  int scorepl = 0;
  List<String> upperTeeth = [
    '17',
    '16',
    '15',
    '14',
    '13',
    '12',
    '11',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27'
  ];
  List<String> lowerTeeth = [
    '47',
    '46',
    '45',
    '44',
    '43',
    '42',
    '41',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37'
  ];

  // Map to store plaque values for each tooth surface.
  // Key format: "ToothNumberSurface" (e.g., "17B", "21P", "47L")
  final Map<String, String> plaqueValues = {};

  PlaqueIndexData() {
    initializePlaqueValues();
  }

  // Initializes all plaque values to empty strings.
  // In PlaqueIndexData class
  void initializePlaqueValues() {
    for (String tooth in upperTeeth) {
      plaqueValues['${tooth}B1'] = '0'; // Buccal/Labial 1
      plaqueValues['${tooth}B2'] = '0'; // Buccal/Labial 2
      plaqueValues['${tooth}B3'] = '0'; // Buccal/Labial 3
      plaqueValues['${tooth}P'] = '0'; // Palatal
    }
    for (String tooth in lowerTeeth) {
      plaqueValues['${tooth}B1'] = '0'; // Buccal/Labial 1
      plaqueValues['${tooth}B2'] = '0'; // Buccal/Labial 2
      plaqueValues['${tooth}B3'] = '0'; // Buccal/Labial 3
      plaqueValues['${tooth}P'] = '0'; // Lingual
    }
  }

  // Gets the plaque value for a specific tooth and surface.
  String getPlaqueValue(String toothNum, String surface) {
    return plaqueValues['$toothNum$surface'] ?? '';
  }

  // Sets the plaque value for a specific tooth and surface.
  void setPlaqueValue(String toothNum, String surface, String value) {
    if (value == '0' ||
        value == '1' ||
        value == '2' ||
        value == '3' ||
        value.isEmpty) {
      plaqueValues['$toothNum$surface'] = value;
      notifyListeners(); // Notify listeners to rebuild widgets that depend on this data
    }
  }
  void updateFromMap(Map<String, dynamic> data) {
  // Reset all values to '0'
  initializePlaqueValues();
  
  try {
    // Update from individualScores if available
    if (data['individualScores'] is Map) {
      final individualScores = data['individualScores'] as Map<String, dynamic>;
      individualScores.forEach((key, value) {
        if (plaqueValues.containsKey(key) && value is String) {
          plaqueValues[key] = value;
        }
      });
    }
    
    // Update from upper teeth scores
    if (data['upperTeethScores'] is Map) {
      final upperScores = data['upperTeethScores'] as Map<String, dynamic>;
      upperScores.forEach((tooth, surfaces) {
        if (surfaces is Map) {
          surfaces.forEach((surface, value) {
            final key = '$tooth$surface';
            if (plaqueValues.containsKey(key) && value is String) {
              plaqueValues[key] = value;
            }
          });
        }
      });
    }
    
    // Update from lower teeth scores
    if (data['lowerTeethScores'] is Map) {
      final lowerScores = data['lowerTeethScores'] as Map<String, dynamic>;
      lowerScores.forEach((tooth, surfaces) {
        if (surfaces is Map) {
          surfaces.forEach((surface, value) {
            final key = '$tooth$surface';
            if (plaqueValues.containsKey(key) && value is String) {
              plaqueValues[key] = value;
            }
          });
        }
      });
    }
    
    // Recalculate the score
    calculateScore();
    notifyListeners();
  } catch (e) {
    debugPrint('Error restoring plaque values: $e');
    // If error occurs, maintain initialized values
  }
}

  // Calculates the total plaque score based on entered '1's.
  int calculateScore() {
    int score = 0;
    plaqueValues.forEach((key, value) {
      if (value != '0' && value != '') {
        score += int.parse(value);
      }
    });
    scorepl = score;
 
    // print(scorepl);

    return score;
  }
}
