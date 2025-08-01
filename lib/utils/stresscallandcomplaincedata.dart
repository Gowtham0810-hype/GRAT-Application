import 'package:flutter/material.dart';

class PatientAssessmentData extends ChangeNotifier {
  // Compliance Rating
  int _complianceRating = 0;
  final List<String> complianceLevels = [
    'Patient completely refuses treatment',
    'Patient reluctantly refuses treatment',
    'Patient reluctantly accepts treatment',
    'Patient occasionally refuses treatment',
    'Patient passively accepts treatment',
    'Patient moderately participates in treatment',
    'Patient actively participates in treatment',
  ];

  // Stress Assessment
  final List<int> _stressAnswers = List.filled(10, 0);
  int _totalStressScore = 0;

  // Getters
  int get complianceRating => _complianceRating;
  String get complianceDescription => complianceLevels[_complianceRating];
  int get totalStressScore => _totalStressScore;
  List<int> get stressAnswers => _stressAnswers;

  int min(int a, int b) {
    if (a > b) {
      return b;
    }
    return a;
  }

  // Setters
  void setComplianceRating(int rating) {
    _complianceRating = rating;
    notifyListeners();
  }

  void setStressAnswer(int index, int value) {
    _stressAnswers[index] = value;
    _calculateTotalStressScore();
    notifyListeners();
  }

  void updateFromMap(Map<String, dynamic> data) {
    try {
      // Reset all values first
      _complianceRating = 0;
      _stressAnswers.fillRange(0, _stressAnswers.length, 0);
      _totalStressScore = 0;

      // Update compliance rating
      if (data['complianceRating'] is int) {
        _complianceRating = data['complianceRating'];
      }

      // Update stress assessment
      if (data['stressAssessment'] is Map) {
        final stressAssessment =
            data['stressAssessment'] as Map<String, dynamic>;

        // Update total stress score
        if (stressAssessment['totalScore'] is int) {
          _totalStressScore = stressAssessment['totalScore'];
        }

        // Update individual answers
        if (stressAssessment['individualResponses'] is List) {
          final responses = stressAssessment['individualResponses'] as List;
          for (int i = 0;
              i < min(responses.length, _stressAnswers.length);
              i++) {
            if (responses[i] is int) {
              _stressAnswers[i] = responses[i];
            }
          }
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error restoring patient assessment data: $e');
      // If error occurs, maintain initialized values
    }
  }

  void _calculateTotalStressScore() {
    // Questions 4,5,7,8 have reverse scoring
    int total = 0;
    for (int i = 0; i < _stressAnswers.length; i++) {
      if ([3, 4, 6, 7].contains(i)) {
        // Reverse scoring for these questions (0-based index)
        total += 4 - _stressAnswers[i];
      } else {
        total += _stressAnswers[i];
      }
    }
    _totalStressScore = total;
  }
}
