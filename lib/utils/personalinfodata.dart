import 'package:flutter/material.dart';

class PersonalinfoData extends ChangeNotifier {
  // Form fields
  DateTime? _date;
  String _patientName = '';
  String _age = '';
  String _height = '';
  String _weight = '';
  String _ethnicity = '';
  String _phoneNumber = '';
  String _education = '';
  String _occupation = '';
  String _familyIncome = '';
  String _visitFrequency = '';
  final List<String> _systemRiskFactors = [];
  final List<String> _brushingHabits = [];
  String _familyHistory = '';
  String _brushingFrequency = '';
  String _drugHistory = '';
  String _smokingStatus = '';
  String _smokelessTobaccoStatus = '';
  String _alcoholStatus = '';

  // Getters
  DateTime? get date => _date;
  String get patientName => _patientName;
  String get age => _age;
  String get height => _height;
  String get weight => _weight;
  double? get bmi {
    if (_height.isEmpty || _weight.isEmpty) return null;
    final height = double.tryParse(_height);
    final weight = double.tryParse(_weight);
    if (height == null || weight == null || height == 0) return null;
    return weight / ((height / 100) * (height / 100));
  }

  String get ethnicity => _ethnicity;
  String get phoneNumber => _phoneNumber;
  String get education => _education;
  String get occupation => _occupation;
  String get familyIncome => _familyIncome;
  String get visitFrequency => _visitFrequency;
  List<String> get systemRiskFactors => _systemRiskFactors;
  List<String> get brushingHabits => _brushingHabits;
  String get brushingFrequency => _brushingFrequency;
  String get drugHistory => _drugHistory;
  String get familyHistory => _familyHistory;
  String get smokingStatus => _smokingStatus;
  String get smokelessTobaccoStatus => _smokelessTobaccoStatus;
  String get alcoholStatus => _alcoholStatus;

  // Education options
  static const List<String> educationOptions = [
    'Professional Degree',
    'Graduate',
    'Intermediate/Diploma',
    'High School',
    'Middle School',
    'Primary School',
    'Illiterate',
  ];

  // Occupation options
  static const List<String> occupationOptions = [
    'Professional',
    'Semi Professional',
    'Clerical',
    'Skilled Worker',
    'Semiskilled Worker',
    'Unskilled Worker',
    'Unemployed',
  ];

  // Family income options
  static const List<String> familyIncomeOptions = [
    '>47,348',
    '>23,674',
    '>17,756',
    '>11,839',
    '>7,102',
    '>2,391',
    '<2,391',
  ];

  // Visit frequency options
  static const List<String> visitFrequencyOptions = [
    'Monthly Once',
    'Yearly Once',
    'Regular',
    '1st Visit',
    '2nd Visit',
    'Others',
  ];

  // System risk factors
  static const List<String> systemRiskFactorOptions = [
    'Diabetes',
    'PCOD/PCOS',
    'Osteoporosis',
  ];

  // Brushing habits options
  static const List<String> brushingHabitsOptions = [
    'Unilateral',
    'Brush & Tooth Paste',
    'Mouthrinse and other aids',
    'Others'
  ];

  // Brushing frequency options
  static const List<String> brushingFrequencyOptions = [
    'Once Daily',
    'Twice Daily',
    'Irregular',
  ];

  // Drug history options
  static const List<String> drugHistoryOptions = [
    'Present',
    'Absent',
  ];
  // Family history options
  static const List<String> familyHistoryOptions = [
    'Gingivits / periodontitis / Diabetes',
    'Others',
  ];
  static const List<String> smokingStatusOptions = [
    'Current Smoker',
    'Former Smoker',
    'Non-Smoker',
  ];

  static const List<String> smokelessTobaccoOptions = [
    'Current User',
    'Former User',
    'Non-User',
  ];

  static const List<String> alcoholStatusOptions = [
    'Current Drinker',
    'Former Drinker',
    'Non-Drinker',
  ];

  // Setters
  void setDate(DateTime? date) {
    _date = date;
    notifyListeners();
  }

  void setPatientName(String value) {
    _patientName = value;
    notifyListeners();
  }

  void setAge(String value) {
    if (value.isEmpty || int.tryParse(value) != null) {
      _age = value;
      notifyListeners();
    }
  }

  void setHeight(String value) {
    if (value.isEmpty || double.tryParse(value) != null) {
      _height = value;
      notifyListeners();
    }
  }

  void setWeight(String value) {
    if (value.isEmpty || double.tryParse(value) != null) {
      _weight = value;
      notifyListeners();
    }
  }

  void setEthnicity(String value) {
    _ethnicity = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setEducation(String? value) {
    if (value != null) {
      _education = value;
      notifyListeners();
    }
  }

  void setOccupation(String? value) {
    if (value != null) {
      _occupation = value;
      notifyListeners();
    }
  }

  void setFamilyIncome(String? value) {
    if (value != null) {
      _familyIncome = value;
      notifyListeners();
    }
  }

  void setVisitFrequency(String? value) {
    if (value != null) {
      _visitFrequency = value;
      notifyListeners();
    }
  }

  void toggleSystemRiskFactor(String factor) {
    if (_systemRiskFactors.contains(factor)) {
      _systemRiskFactors.remove(factor);
    } else {
      _systemRiskFactors.add(factor);
    }
    notifyListeners();
  }

 void toggleSbrushinghabits(String factor) {
    if (_brushingHabits.contains(factor)) {
      _brushingHabits.remove(factor);
    } else {
      _brushingHabits.add(factor);
    }
    notifyListeners();
  }

  void setBrushingFrequency(String? value) {
    if (value != null) {
      _brushingFrequency = value;
      notifyListeners();
    }
  }

  void setDrugHistory(String? value) {
    if (value != null) {
      _drugHistory = value;
      notifyListeners();
    }
  }

  void setfamilyHistory(String? value) {
    if (value != null) {
      _familyHistory = value;
      notifyListeners();
    }
  }

  void setSmokingStatus(String? value) {
    if (value != null) {
      _smokingStatus = value;
      notifyListeners();
    }
  }

  void setSmokelessTobaccoStatus(String? value) {
    if (value != null) {
      _smokelessTobaccoStatus = value;
      notifyListeners();
    }
  }

  void setAlcoholStatus(String? value) {
    if (value != null) {
      _alcoholStatus = value;
      notifyListeners();
    }
  }

  void clearForm() {
    _date = null;
    _patientName = '';
    _age = '';
    _height = '';
    _weight = '';
    _ethnicity = '';
    _phoneNumber = '';
    _education = '';
    _occupation = '';
    _familyIncome = '';
    _visitFrequency = '';
    _systemRiskFactors.clear();
    _brushingHabits.clear();
    _brushingFrequency = '';
    _drugHistory = '';
    _familyHistory = '';
    _smokelessTobaccoStatus = '';
    _smokingStatus = '';
    _alcoholStatus = '';
    notifyListeners();
  }

  void updateFromMap(Map<String, dynamic> data) {
  try {
    // Reset all values first
    clearForm();

    // Update date
    if (data['examinationDate'] is String) {
      _date = DateTime.tryParse(data['examinationDate']);
    }

    // Update simple string fields
    _patientName = data['patientName']?.toString() ?? '';
    _age = data['age']?.toString() ?? '';
    _height = data['height']?.toString() ?? '';
    _weight = data['weight']?.toString() ?? '';
    _ethnicity = data['ethnicity']?.toString() ?? '';
    _phoneNumber = data['contactNumber']?.toString() ?? '';
    _education = data['educationLevel']?.toString() ?? '';
    _occupation = data['occupation']?.toString() ?? '';
    _familyIncome = data['familyIncome']?.toString() ?? '';
    _visitFrequency = data['dentalVisitFrequency']?.toString() ?? '';
  
    _brushingFrequency = data['brushingFrequency']?.toString() ?? '';
    _drugHistory = data['medicationHistory']?.toString() ?? '';
    _familyHistory = data['familyDentalHistory']?.toString() ?? '';
    _smokingStatus = data['tobaccoSmokingStatus']?.toString() ?? '';
    _smokelessTobaccoStatus = data['smokelessTobaccoStatus']?.toString() ?? '';
    _alcoholStatus = data['alcoholConsumption']?.toString() ?? '';

    // Update system risk factors (List)
    if (data['systemicRiskFactors'] is List) {
      _systemRiskFactors.addAll(
        (data['systemicRiskFactors'] as List)
            .whereType<String>()
            .where((factor) => systemRiskFactorOptions.contains(factor))
      );
    } else if (data['systemicRiskFactors'] is String) {
      // Handle case where it might be stored as a single string
      final factor = data['systemicRiskFactors'] as String;
      if (systemRiskFactorOptions.contains(factor)) {
        _systemRiskFactors.add(factor);
      }
    }
    // Update brushing habits (List)
    if (data['brushingTechnique'] is List) {
      _brushingHabits.addAll(
        (data['brushingTechnique'] as List)
            .whereType<String>()
            .where((factor) => brushingHabitsOptions.contains(factor))
      );
    } else if (data['brushingTechnique'] is String) {
      // Handle case where it might be stored as a single string
      final factor = data['brushingTechnique'] as String;
      if (systemRiskFactorOptions.contains(factor)) {
        _brushingHabits.add(factor);
      }
    }


    notifyListeners();
  } catch (e) {
    debugPrint('Error restoring personal information data: $e');
    // If error occurs, maintain cleared form
    clearForm();
  }
}

  Map<String, dynamic> toJson() {
    return {
      'date': _date?.toIso8601String(),
      'patientName': _patientName,
      'age': _age,
      'height': _height,
      'weight': _weight,
      'bmi': bmi,
      'ethnicity': _ethnicity,
      'phoneNumber': _phoneNumber,
      'education': _education,
      'occupation': _occupation,
      'familyIncome': _familyIncome,
      'visitFrequency': _visitFrequency,
      'systemRiskFactors': _systemRiskFactors.toList(),
      'brushingHabits': _brushingHabits.toList(),
      'brushingFrequency': _brushingFrequency,
      'drugHistory': _drugHistory,
      'familhistory':_familyHistory,
      'smokingStatus': _smokingStatus,
      'smokelessTobaccoStatus': _smokelessTobaccoStatus,
      'alcoholStatus': _alcoholStatus,
    };
  }
}
