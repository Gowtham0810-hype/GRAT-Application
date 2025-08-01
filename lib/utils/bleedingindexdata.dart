import 'package:flutter/material.dart';

class BleedingIndexData extends ChangeNotifier {
  List<String> upperTeeth = ['18', '17', '16', '15', '14', '13', '12', '11', '21', '22', '23', '24', '25', '26', '27', '28'];
  List<String> lowerTeeth = ['48', '47', '46', '45', '44', '43', '42', '41', '31', '32', '33', '34', '35', '36', '37', '38'];

  // Map to store bleeding values for each tooth site
  // Key format: "ToothNumber_Site" (e.g., "17_1", "21_4")
  // Each tooth has 4 sites (1-4 representing the 4 triangles)
  final Map<String, bool> bleedingValues = {};

  BleedingIndexData() {
    initializeBleedingValues();
  }
  
  void initializeBleedingValues() {
    for (String tooth in upperTeeth) {
      for (int site = 1; site <= 4; site++) {
        bleedingValues['${tooth}_$site'] = false; // Initialize all as negative (no bleeding)
      }
    }
    for (String tooth in lowerTeeth) {
      for (int site = 1; site <= 4; site++) {
        bleedingValues['${tooth}_$site'] = false; // Initialize all as negative (no bleeding)
      }
    }
  }

  bool getBleedingValue(String toothNum, int site) {
    return bleedingValues['${toothNum}_$site'] ?? false;
  }

  void toggleBleedingValue(String toothNum, int site) {
    bleedingValues['${toothNum}_$site'] = !(bleedingValues['${toothNum}_$site'] ?? false);
    notifyListeners();
  }

  int calculateScore() {
    int score = 0;
    bleedingValues.forEach((key, value) {
      if (value) {
        score++;
      }
    });
    return score;
  }

  void updateFromMap(Map<String, dynamic> data) {
    // First reset all values to false
    initializeBleedingValues();
    
    try {
      // Check if we have bleeding data to restore from upper arch
      if (data['upperArchBleedingSites'] is Map) {
        final upperSites = data['upperArchBleedingSites'] as Map<String, dynamic>;
        upperSites.forEach((key, value) {
          if (value == true) {
            bleedingValues[key] = true;
          }
        });
      }
      
      // Check if we have bleeding data to restore from lower arch
      if (data['lowerArchBleedingSites'] is Map) {
        final lowerSites = data['lowerArchBleedingSites'] as Map<String, dynamic>;
        lowerSites.forEach((key, value) {
          if (value == true) {
            bleedingValues[key] = true;
          }
        });
      }
      
      // Alternatively, you could also check the combined bleedingSites map
      if (data['bleedingSites'] is Map) {
        final allSites = data['bleedingSites'] as Map<String, dynamic>;
        allSites.forEach((key, value) {
          if (value == true && bleedingValues.containsKey(key)) {
            bleedingValues[key] = true;
          }
        });
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error restoring bleeding values: $e');
      // If there's an error, just keep the initialized values
    }
  }

  double calculatePercentage() {
    if (bleedingValues.isEmpty) return 0.0;
    int totalSites = 128;
    int positiveSites = calculateScore();
    return (positiveSites / totalSites) * 100;
  }
}