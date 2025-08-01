// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_new/components/buttonsign.dart';
import 'package:dental_new/forms/bleedingindex.dart';
import 'package:dental_new/forms/gingivalpage.dart';
import 'package:dental_new/forms/mouthindex.dart';
import 'package:dental_new/forms/ohispage.dart';
import 'package:dental_new/forms/personalinfo.dart';
import 'package:dental_new/forms/probingpage.dart';
import 'package:dental_new/forms/stresscallcompliance.dart';
import 'package:dental_new/utils/bleedingindexdata.dart';
import 'package:dental_new/utils/gingivalindexdata.dart';
import 'package:dental_new/utils/ohisdata.dart';
import 'package:dental_new/utils/personalinfodata.dart';
import 'package:dental_new/utils/plaqueindexdata.dart';
import 'package:dental_new/utils/probingdata.dart';
import 'package:dental_new/utils/riskscore.dart';
import 'package:dental_new/utils/stresscallandcomplaincedata.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Reportpage extends StatefulWidget {
  const Reportpage({super.key});

  @override
  State<Reportpage> createState() => _ReportpageState();
}

class _ReportpageState extends State<Reportpage> {
  final _patientinforiskscore = TextEditingController();
  final _bmiController = TextEditingController();
  double _bmi = 0;
  TabController? _internalTabController;
  late List<TabData> tabs;

  @override
  void initState() {
    super.initState();

    // Initialize tabs
    tabs = [
      TabData(
        index: 1,
        title: const Tab(child: Text('Patient Info')),
        content: Personalinfo(),
      ),
      TabData(
        index: 2,
        title: const Tab(child: Text('Plaque Index')),
        content: const Center(child: PlaqueIndexScreen()),
      ),
      TabData(
          index: 3,
          title: const Tab(child: Text('Oral Hygiene Index')),
          content: OHISScreen()),
      TabData(
        index: 4,
        title: const Tab(text: "Bleeding Index"),
        content: Bleedingindex(),
      ),
      TabData(
        index: 5,
        title: const Tab(text: "Gingival Index"),
        content: GingivalIndexScreen(),
      ),
      TabData(
        index: 6,
        title: const Tab(text: "Probing Depth"),
        content: PeriodontalProbingPage(),
      ),
      TabData(
        index: 6,
        title: const Tab(child: Text('Stress Assessment')),
        content: const Center(child: PatientAssessmentScreen()),
      ),
    ];

    // Initialize listeners for all providers that affect risk score
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final providers = [
        Provider.of<PersonalinfoData>(context, listen: false),
        Provider.of<PlaqueIndexData>(context, listen: false),
        Provider.of<OHISData>(context, listen: false),
        Provider.of<BleedingIndexData>(context, listen: false),
        Provider.of<Gingivalindexdata>(context, listen: false),
        Provider.of<PeriodontalProbingProvider>(context, listen: false),
        Provider.of<PatientAssessmentData>(context, listen: false),
      ];

      for (var provider in providers) {
        provider.addListener(_updateRiskScore);
      }

      _updateRiskScore();
    });
  }

  @override
  void dispose() {
    final providers = [
      Provider.of<PersonalinfoData>(context, listen: false),
      Provider.of<PlaqueIndexData>(context, listen: false),
      Provider.of<OHISData>(context, listen: false),
      Provider.of<BleedingIndexData>(context, listen: false),
      Provider.of<Gingivalindexdata>(context, listen: false),
      Provider.of<PeriodontalProbingProvider>(context, listen: false),
      Provider.of<PatientAssessmentData>(context, listen: false),
    ];

    for (var provider in providers) {
      provider.removeListener(_updateRiskScore);
    }

    _patientinforiskscore.dispose();
    super.dispose();
  }

  void _updateRiskScore() {
    final overallRisk = RiskScoreCalculator.calculateOverallRisk(context);
    setState(() {
      _patientinforiskscore.text = overallRisk;
    });
  }

  Color _getRiskColor(String risk) {
    if (risk == 'High') return Colors.red;
    if (risk == 'Moderate') return Colors.orange;
    return Colors.green;
  }

  Future<void> _saveToFirestore(Map<String, dynamic> data) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final firestore = FirebaseFirestore.instance;
      final phoneNumber = data['patientInformation']['contactNumber'] as String;

      // Use phone number as document ID
      await firestore
          .collection('dentalAssessments')
          .doc(user.uid)
          .collection('patientRecords')
          .doc(phoneNumber) // Phone number as document ID
          .set(data, SetOptions(merge: true));

      print('Data saved with phone number as ID: $phoneNumber');
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }

  void _exportAllData() async {
    showDialog(
      context: context,
      barrierDismissible: false, // User must wait for process to finish
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 5, 89, 157),
          ),
        );
      },
    );

    // Get all provider data
    final personalData = Provider.of<PersonalinfoData>(context, listen: false);
    final plaqueData = Provider.of<PlaqueIndexData>(context, listen: false);
    final ohiData = Provider.of<OHISData>(context, listen: false);
    final bleedingData = Provider.of<BleedingIndexData>(context, listen: false);
    final gingivalData = Provider.of<Gingivalindexdata>(context, listen: false);
    final probingData =
        Provider.of<PeriodontalProbingProvider>(context, listen: false);
    final assessmentData =
        Provider.of<PatientAssessmentData>(context, listen: false);

    final riskScore = _patientinforiskscore.text;

    // Validate required fields
    if (personalData.patientName.isEmpty ||
        personalData.age.isEmpty ||
        personalData.phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Please fill all required fields (Name, Age, Contact)'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
      return;
    }

    // Prepare comprehensive data structure
    final data = {
      'patientInformation': {
        'examinationDate': personalData.date?.toIso8601String(),
        'patientName': personalData.patientName,
        'age': personalData.age,
        'height': personalData.height,
        'weight': personalData.weight,
        'bmi': personalData.bmi,
        'ethnicity': personalData.ethnicity,
        'contactNumber': personalData.phoneNumber,
        'educationLevel': personalData.education,
        'occupation': personalData.occupation,
        'familyIncome': personalData.familyIncome,
        'dentalVisitFrequency': personalData.visitFrequency,
        'systemicRiskFactors': personalData.systemRiskFactors,
        'brushingTechnique': personalData.brushingHabits,
        'brushingFrequency': personalData.brushingFrequency,
        'medicationHistory': personalData.drugHistory,
        'familyDentalHistory': personalData.familyHistory,
        'tobaccoSmokingStatus': personalData.smokingStatus,
        'smokelessTobaccoStatus': personalData.smokelessTobaccoStatus,
        'alcoholConsumption': personalData.alcoholStatus,
      },
      'plaqueIndexAssessment': {
        'totalScore': plaqueData.scorepl,
        'averageScore': plaqueData.scorepl / 112,
        'individualScores': {
          for (var entry in plaqueData.plaqueValues.entries)
            entry.key: entry.value,
        },
        'upperTeethScores': {
          for (var tooth in plaqueData.upperTeeth)
            tooth: {
              'B1': plaqueData.getPlaqueValue(tooth, 'B1'),
              'B2': plaqueData.getPlaqueValue(tooth, 'B2'),
              'B3': plaqueData.getPlaqueValue(tooth, 'B3'),
              'P': plaqueData.getPlaqueValue(tooth, 'P'),
            },
        },
        'lowerTeethScores': {
          for (var tooth in plaqueData.lowerTeeth)
            tooth: {
              'B1': plaqueData.getPlaqueValue(tooth, 'B1'),
              'B2': plaqueData.getPlaqueValue(tooth, 'B2'),
              'B3': plaqueData.getPlaqueValue(tooth, 'B3'),
              'P': plaqueData.getPlaqueValue(tooth, 'P'),
            },
        },
      },
      'oralHygieneIndexSimplified': {
        'overallScore': ohiData.calculateOHISScore(),
        'debrisIndex': {
          'score': ohiData.calculateDISScore(),
          'individualScores': {
            for (var tooth in ohiData.diSTeeth)
              tooth: ohiData.getDISValue(tooth),
          },
        },
        'calculusIndex': {
          'score': ohiData.calculateCISScore(),
          'individualScores': {
            for (var tooth in ohiData.ciSTeeth)
              tooth: ohiData.getCISValue(tooth),
          },
        },
        'riskLevel': ohiData.getRiskLevel(),
      },
      'bleedingIndexAssessment': {
        'positiveSitesCount': bleedingData.calculateScore(),
        'bleedingPercentage': bleedingData.calculatePercentage(),
        'bleedingSites': {
          for (var entry in bleedingData.bleedingValues.entries)
            if (entry.value) entry.key: entry.value,
        },
        'upperArchBleedingSites': {
          for (var tooth in bleedingData.upperTeeth)
            for (int site = 1; site <= 4; site++)
              if (bleedingData.getBleedingValue(tooth, site))
                '${tooth}_$site': true,
        },
        'lowerArchBleedingSites': {
          for (var tooth in bleedingData.lowerTeeth)
            for (int site = 1; site <= 4; site++)
              if (bleedingData.getBleedingValue(tooth, site))
                '${tooth}_$site': true,
        },
      },
      'gingivalIndexAssessment': {
        'totalScore': gingivalData.ging_scorepl,
        'averageScore': gingivalData.ging_scorepl / 112,
        'individualScores': {
          for (var entry in gingivalData.gingivalValues.entries)
            entry.key: entry.value,
        },
        'upperTeethScores': {
          for (var tooth in gingivalData.upperTeeth)
            tooth: {
              'B1': gingivalData.getgingivalValue(tooth, 'B1'),
              'B2': gingivalData.getgingivalValue(tooth, 'B2'),
              'B3': gingivalData.getgingivalValue(tooth, 'B3'),
              'P': gingivalData.getgingivalValue(tooth, 'P'),
            },
        },
        'lowerTeethScores': {
          for (var tooth in gingivalData.lowerTeeth)
            tooth: {
              'B1': gingivalData.getgingivalValue(tooth, 'B1'),
              'B2': gingivalData.getgingivalValue(tooth, 'B2'),
              'B3': gingivalData.getgingivalValue(tooth, 'B3'),
              'P': gingivalData.getgingivalValue(tooth, 'P'),
            },
        },
      },
      'periodontalAssessment': {
        'teethWithProbingDepth': probingData.teethWithProbingDepth,
        'missingTeethCount': probingData.missingTeeth,
        'teethWithRecession': probingData.recessionTeeth,
        'identifiedRiskFactors': probingData.toothFactors.toList(),
        'probingStatus': {
          'upperTeeth': {
            for (var tooth in probingData.upperTeeth)
              tooth: probingData.getProbingValue(tooth),
          },
          'lowerTeeth': {
            for (var tooth in probingData.lowerTeeth)
              tooth: probingData.getProbingValue(tooth),
          },
        },
      },
      'patientComplianceAssessment': {
        'complianceRating': assessmentData.complianceRating,
        'complianceDescription': assessmentData.complianceDescription,
        'stressAssessment': {
          'totalScore': assessmentData.totalStressScore,
          'individualResponses': assessmentData.stressAnswers,
        },
      },
      'riskAssessment': {
        'calculatedRiskScore': riskScore,
      },
      'metadata': {
        'exportTimestamp': DateTime.now().toIso8601String(),
      },
    };

    try {
      // Save to Firestore
      await _saveToFirestore(data);
      _resetAllProviders(personalData, plaqueData, ohiData, bleedingData,
          gingivalData, probingData, assessmentData);
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report saved successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      Navigator.pop(context);

      // Show error message if saving fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save report: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetAllProviders(
    PersonalinfoData personalData,
    PlaqueIndexData plaqueData,
    OHISData ohiData,
    BleedingIndexData bleedingData,
    Gingivalindexdata gingivalData,
    PeriodontalProbingProvider probingData,
    PatientAssessmentData assessmentData,
  ) {
    // Clear personal info
    personalData.clearForm();

    // Reset plaque index data
    plaqueData.initializePlaqueValues();
    plaqueData.scorepl = 0;

    // Reset OHI-S data
    ohiData.initializeValues();

    // Reset bleeding index data
    bleedingData.initializeBleedingValues();

    // Reset gingival index data
    gingivalData.initializegingivalValues();
    gingivalData.ging_scorepl = 0;

    // Reset periodontal probing data
    probingData.initializeValues();
    probingData.missingTeeth = 0;
    probingData.recessionTeeth = 0;
    probingData.toothFactors.clear();

    // Reset patient assessment data
    assessmentData.setComplianceRating(0);
    for (int i = 0; i < assessmentData.stressAnswers.length; i++) {
      assessmentData.setStressAnswer(i, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              // Risk Score Displayaa

              // Tab Bar
              Expanded(
                child: DynamicTabBarWidget(
                  dynamicTabs: tabs,
                  dividerHeight: 2,
                  dividerColor: Colors.grey.shade300,
                  labelStyle: TextStyle(color: Color.fromARGB(255, 5, 89, 157)),
                  indicatorColor: Color.fromARGB(255, 5, 89, 157),
                  isScrollable: true,
                  showBackIcon: false,
                  showNextIcon: false,
                  onTabControllerUpdated: (controller) {
                    if (_internalTabController != controller) {
                      _internalTabController = controller;
                      _internalTabController?.index = 0;
                    }
                  },
                  onTabChanged: (index) {},
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Risk Score Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment
                              .baseline, // Aligns text baselines
                          textBaseline: TextBaseline
                              .alphabetic, // Standard baseline alignment
                          children: [
                            const Text(
                              'RISK SCORE: ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 80),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Baseline(
                                baseline: 17, // Matches your font size
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  _patientinforiskscore.text,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: _getRiskColor(
                                        _patientinforiskscore.text),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      // Submit Button
                      Container(
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton.icon(
                          onPressed: _exportAllData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            padding: const EdgeInsets.symmetric(
                              horizontal:
                                  16, // Slightly reduced for better balance
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(
                                140, 48), // Ensures consistent touch target
                            tapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // Better visual alignment
                          ),
                          icon: const Icon(
                            Icons.save_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: const Padding(
                            padding: EdgeInsets.only(
                                left: 4), // Better icon-text spacing
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5, // Improves readability
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ),
            ],
          ),
        ),
      ),
    );
  }
}
