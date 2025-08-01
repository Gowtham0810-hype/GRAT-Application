import 'package:dental_new/utils/bleedingindexdata.dart';
import 'package:dental_new/utils/gingivalindexdata.dart';
import 'package:dental_new/utils/ohisdata.dart';
import 'package:dental_new/utils/personalinfodata.dart';
import 'package:dental_new/utils/plaqueindexdata.dart';
import 'package:dental_new/utils/probingdata.dart';
import 'package:dental_new/utils/stresscallandcomplaincedata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RiskScoreCalculator {
  // Education scores
  static const Map<String, int> educationScores = {
    'Professional Degree': 7,
    'Graduate': 6,
    'Intermediate/Diploma': 5,
    'High School': 4,
    'Middle School': 3,
    'Primary School': 2,
    'Illiterate': 1,
  };

  // Occupation scores
  static const Map<String, int> occupationScores = {
    'Professional': 10,
    'Semi Professional': 6,
    'Clerical': 5,
    'Skilled Worker': 4,
    'Semiskilled Worker': 3,
    'Unskilled Worker': 2,
    'Unemployed': 1,
  };

  // Family income scores
  static const Map<String, int> familyIncomeScores = {
    '>47,348': 12,
    '>23,674': 10,
    '>17,756': 6,
    '>11,839': 4,
    '>7,102': 3,
    '>2,391': 2,
    '<2,391': 1,
  };
  //json export

  // Calculate socioeconomic class
  static String calculateSocioEconomicClass(
      int educationScore, int occupationScore, int incomeScore) {
    final total = educationScore + occupationScore + incomeScore;

    if (total >= 26) return 'Upper Class';
    if (total >= 16) return 'Upper Middle';
    if (total >= 11) return 'Lower Middle';
    if (total >= 5) return 'Upper Lower';
    return 'Lower';
  }

  // Calculate BMI category
  static String calculateBmiCategory(double bmi) {
    if (bmi >= 18.5 && bmi <= 24.9) return 'low';
    if (bmi >= 25 && bmi <= 29.9) return 'moderate';
    return 'high';
  }

  // Visit frequency scores
  static const Map<String, String> visitFrequencyScores = {
    'Monthly Once': 'low',
    'Yearly Once': 'low',
    'Regular': 'low',
    '1st Visit': 'high',
    '2nd Visit': 'high',
    'Others': 'moderate',
  };

  // Brushing habits scores
  static const Map<String, String> brushingHabitsScores = {
    'Unilateral': 'high',
    'Brush & Tooth Paste': 'low',
    'Mouthrinse and other aids': 'low',
    'Others': 'high',
  };

  // Brushing frequency scores
  static const Map<String, String> brushingFrequencyScores = {
    'Once Daily': 'moderate',
    'Twice Daily': 'low',
    'Irregular': 'high',
  };

  // Drug history scores
  static const Map<String, String> drugHistoryScores = {
    'Present': 'high',
    'Absent': 'low',
  };

  // family history scores
  static const Map<String, String> famHistoryScores = {
    'Gingivits / periodontitis / Diabetes': 'high',
    'Others': 'low',
  };

  // Smoking status scores
  static const Map<String, String> smokingStatusScores = {
    'Current Smoker': 'high',
    'Former Smoker': 'moderate',
    'Non-Smoker': 'low',
  };

  // Smokeless tobacco scores
  static const Map<String, String> smokelessTobaccoScores = {
    'Current User': 'high',
    'Former User': 'moderate',
    'Non-User': 'low',
  };

  // Alcohol status scores
  static const Map<String, String> alcoholStatusScores = {
    'Current Drinker': 'high',
    'Former Drinker': 'moderate',
    'Non-Drinker': 'low',
  };

  static String calculateOverallRisk(BuildContext context) {
    // Get all providers
    final personalData = Provider.of<PersonalinfoData>(context, listen: false);
    final plaqueData = Provider.of<PlaqueIndexData>(context, listen: false);
    final ohiData = Provider.of<OHISData>(context, listen: false);
    final bleedingData = Provider.of<BleedingIndexData>(context, listen: false);
    final gingivalData = Provider.of<Gingivalindexdata>(context, listen: false);
    final probingData =
        Provider.of<PeriodontalProbingProvider>(context, listen: false);
    final assessmentData =
        Provider.of<PatientAssessmentData>(context, listen: false);

    // Get all necessary values
    final education = personalData.education ?? '';
    final occupation = personalData.occupation ?? '';
    final familyIncome = personalData.familyIncome ?? '';
    final visitFrequency = personalData.visitFrequency ?? '';
    final systemRiskFactors = personalData.systemRiskFactors ?? [];
    final brushingHabit = personalData.brushingHabits ?? [];
    final brushingFrequency = personalData.brushingFrequency ?? '';
    final drugHistory = personalData.drugHistory ?? '';
    final famHistory = personalData.familyHistory ?? '';
    final smokingStatus = personalData.smokingStatus ?? '';
    final smokelessTobacco = personalData.smokelessTobaccoStatus ?? '';
    final alcoholStatus = personalData.alcoholStatus ?? '';
    final plaqueScore = plaqueData.scorepl;
    final ohiScore = ohiData.calculateOHISScore();

    // Calculate BMI
    double? bmi;
    try {
      final height = personalData.height != null
          ? double.tryParse(personalData.height!)
          : null;
      final weight = personalData.weight != null
          ? double.tryParse(personalData.weight!)
          : null;
      if (height != null && weight != null && height > 0) {
        bmi = weight / ((height / 100) * (height / 100));
      }
    } catch (e) {
      bmi = null;
    }

    // Calculate scores
    int highCount = 0;
    int moderateCount = 0;
    int lowCount = 0;

    // 1. Socioeconomic class
    final socioEconomicClass = calculateSocioEconomicClass(
      educationScores[education] ?? 0,
      occupationScores[occupation] ?? 0,
      familyIncomeScores[familyIncome] ?? 0,
    );
    if (socioEconomicClass == 'Upper Class' ||
        socioEconomicClass == 'Upper Middle' ||
        socioEconomicClass == 'Lower Middle') {
      lowCount++;
    } else {
      highCount++;
    }

    // 2. BMI
    final bmiCategory = bmi != null ? calculateBmiCategory(bmi) : 'low';
    if (bmiCategory == 'high') {
      highCount++;
    } else if (bmiCategory == 'moderate') {
      moderateCount++;
    } else {
      lowCount++;
    }

    // 3. Visit frequency
    final visitScore = visitFrequencyScores[visitFrequency] ?? 'low';
    if (visitScore == 'high')
      highCount++;
    else if (visitScore == 'moderate')
      moderateCount++;
    else
      lowCount++;

    // 4. System risk factors
    if (systemRiskFactors.isNotEmpty)
      highCount++;
    else
      lowCount++;

    // 5. Brushing habits
    // Assuming brushingHabits is now a List<String>
    // 5. Brushing habits
    for (final brushingHabit in brushingHabit) {
      final brushingHabitScore =
          brushingHabitsScores[brushingHabit] ?? 'low'; // Default to 'low' if not found

      if (brushingHabitScore == 'high') {
        highCount++;
      } else if (brushingHabitScore == 'moderate') {
        moderateCount++;
      } else {
        lowCount++;
      }
    }
    // 6. Brushing frequency
    final brushingFreqScore =
        brushingFrequencyScores[brushingFrequency] ?? 'low';
    if (brushingFreqScore == 'high')
      highCount++;
    else if (brushingFreqScore == 'moderate')
      moderateCount++;
    else
      lowCount++;

    // 7. Drug history
    final drugScore = drugHistoryScores[drugHistory] ?? 'low';
    if (drugScore == 'high')
      highCount++;
    else if (drugScore == 'moderate')
      moderateCount++;
    else
      lowCount++;

    // 8. Family history
    final famScore = famHistoryScores[famHistory] ?? 'low';
    if (famScore == 'high')
      highCount++;
    else
      lowCount++;

    // 9. Smoking status
    final smokingScore = smokingStatusScores[smokingStatus] ?? 'low';
    if (smokingScore == 'high')
      highCount++;
    else if (smokingScore == 'moderate')
      moderateCount++;
    else
      lowCount++;

    // 10. Smokeless tobacco
    final tobaccoScore = smokelessTobaccoScores[smokelessTobacco] ?? 'low';
    if (tobaccoScore == 'high')
      highCount++;
    else if (tobaccoScore == 'moderate')
      moderateCount++;
    else
      lowCount++;

    // 11. Alcohol status
    final alcoholScore = alcoholStatusScores[alcoholStatus] ?? 'low';
    if (alcoholScore == 'high')
      highCount++;
    else if (alcoholScore == 'moderate')
      moderateCount++;
    else
      lowCount++;

    // 12. Plaque index score
    final double plaqueAvgScore = plaqueScore / 112;
    if (plaqueAvgScore >= 2.0)
      highCount++;
    else if (plaqueAvgScore >= 1.0)
      moderateCount++;
    else
      lowCount++;

    // 13. OHIS score
    if (ohiScore >= 3.1)
      highCount++;
    else if (ohiScore >= 1.3)
      moderateCount++;
    else
      lowCount++;

    // 14. Bleeding index score
    final bleedingPercentage = bleedingData.calculatePercentage();
    if (bleedingPercentage > 30)
      highCount++;
    else if (bleedingPercentage >= 10)
      moderateCount++;
    else
      lowCount++;

    // 15. Gingival index score
    final double gingivalAvgScore = gingivalData.ging_scorepl / 112;
    if (gingivalAvgScore > 2.0)
      highCount++;
    else if (gingivalAvgScore > 1.0)
      moderateCount++;
    else
      lowCount++;

    // 16. Periodontal probing data
    final probingTeethCount = probingData.teethWithProbingDepth;
    if (probingTeethCount > 10)
      highCount++;
    else if (probingTeethCount >= 5)
      moderateCount++;
    else
      lowCount++;

    // 17. Missing teeth
    final missingTeethCount = probingData.missingTeeth;
    if (missingTeethCount > 5)
      highCount++;
    else if (missingTeethCount >= 1)
      moderateCount++;
    else
      lowCount++;

    // 18. Recession teeth
    final recessionTeethCount = probingData.recessionTeeth;
    if (recessionTeethCount > 5)
      highCount++;
    else if (recessionTeethCount >= 1)
      moderateCount++;
    else
      lowCount++;

    // 19. Tooth factors
    if (probingData.toothFactors.isNotEmpty)
      highCount++;
    else
      lowCount++;

    // 20. Patient assessment - compliance
    final complianceRating = assessmentData.complianceRating;
    if (complianceRating >= 1 && complianceRating <= 3)
      highCount++;
    else if (complianceRating >= 4 && complianceRating < 6)
      moderateCount++;
    else
      lowCount++;

    // 21. Patient assessment - stress score
    final stressScore = assessmentData.totalStressScore;
    if (stressScore > 26)
      highCount++;
    else if (stressScore >= 14)
      moderateCount++;
    else
      lowCount++;

    // Determine final risk
    int totalFactors = highCount + moderateCount + lowCount;
    if (totalFactors == 0) return 'Low';

    double score =
        (highCount * 3 + moderateCount * 2 + lowCount * 1) / totalFactors;
    print(highCount);
    print(moderateCount);
    print(lowCount);
    if (score >= 2.5) return 'High';
    if (score >= 1.5) return 'Moderate';
    return 'Low';
  }
}
