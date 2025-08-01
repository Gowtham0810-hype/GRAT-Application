import 'package:dental_new/pages/reportpage.dart';
import 'package:dental_new/utils/bleedingindexdata.dart';
import 'package:dental_new/utils/gingivalindexdata.dart';
import 'package:dental_new/utils/ohisdata.dart';
import 'package:dental_new/utils/personalinfodata.dart';
import 'package:dental_new/utils/plaqueindexdata.dart';
import 'package:dental_new/utils/probingdata.dart';
import 'package:dental_new/utils/stresscallandcomplaincedata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_new/components/profilecard.dart';
import 'package:provider/provider.dart';

class Patientrecordpage extends StatefulWidget {
  const Patientrecordpage({super.key});

  @override
  State<Patientrecordpage> createState() => _PatientrecordpageState();
}

class _PatientrecordpageState extends State<Patientrecordpage> {
  final TextEditingController _searchQueryController = TextEditingController();
  List<Map<String, dynamic>> filteredPatients = [];
  List<Map<String, dynamic>> allPatients = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
    _searchQueryController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchQueryController.removeListener(_onSearchChanged);
    _searchQueryController.dispose();
    super.dispose();
  }

  Future<void> _fetchPatients() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final query = FirebaseFirestore.instance
          .collection('dentalAssessments')
          .doc(currentUser.uid)
          .collection('patientRecords')
          .orderBy('metadata.exportTimestamp', descending: true);

      final querySnapshot = await query.get();

      final patients = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'patientname':
              data['patientInformation']?['patientName'] ?? 'Unknown',
          'phonenumber': data['patientInformation']?['contactNumber'] ?? '',
          'score': data['riskAssessment']?['calculatedRiskScore'] ?? '0' ?? 0,
          'fullData': data,
        };
      }).toList();

      setState(() {
        allPatients = patients; // Store the complete list
        filteredPatients =
            patients; // Initialize filtered list with all patients
        _isLoading = false;
      });
    } catch (e, stack) {
      print('Error fetching patients: $e');
      print('Stack trace: $stack');
      setState(() {
        _errorMessage = 'Failed to load patient data. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchQueryController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // When search is empty, show all patients
        filteredPatients = List.from(allPatients);
      } else {
        // Filter from the complete list (allPatients)
        filteredPatients = allPatients.where((patient) {
          final nameLower = patient['patientname'].toString().toLowerCase();
          final phoneLower = patient['phonenumber'].toString().toLowerCase();
          return nameLower.contains(query) || phoneLower.contains(query);
        }).toList();
      }
    });
  }
  void _showPatientDetails(BuildContext context, Map<String, dynamic> patientData) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        patientData['patientInformation']['patientName'] ?? 'Patient Details',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            _buildReportSection('Patient Information', [
              _buildDetailItem('Examination Date',
                  patientData['patientInformation']['examinationDate']),
              _buildDetailItem('Age', patientData['patientInformation']['age']),
              _buildDetailItem('Contact',
                  patientData['patientInformation']['contactNumber']),
            ]),
            
            const SizedBox(height: 16),
            _buildReportSection('Assessment Scores', [
              _buildDetailItem('Risk Level',
                  patientData['riskAssessment']['calculatedRiskScore']),
              _buildDetailItem('Plaque Index',
                  patientData['plaqueIndexAssessment']['totalScore']),
              _buildDetailItem('OHI-S Score',
                  patientData['oralHygieneIndexSimplified']['overallScore']),
              _buildDetailItem('Bleeding %',
                  patientData['bleedingIndexAssessment']['bleedingPercentage']),
              _buildDetailItem('Gingival Index',
                  patientData['gingivalIndexAssessment']['totalScore']),
            ]),
            
            const SizedBox(height: 16),
            _buildRiskRecommendations(patientData['riskAssessment']['calculatedRiskScore']),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

// Helper methods (place these in the same class):

Widget _buildReportSection(String title, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.blue[800],
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    ],
  );
}

Widget _buildDetailItem(String label, dynamic value) {
  String displayValue;
  
  // Handle null values
  if (value == null) {
    displayValue = 'N/A';
  } 
  // Handle date values (parse and format)
  else if (_isDateString(value.toString())) {
    displayValue = _formatDate(value.toString());
  }
  // Handle numeric values (round to 2 decimal places)
  else if (double.tryParse(value.toString()) != null) {
    displayValue = _formatNumber(value.toString());
  }
  // Handle text values
  else {
    displayValue = value.toString();
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            displayValue,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

// Helper function to check if string is a date
bool _isDateString(String value) {
  try {
    DateTime.parse(value);
    return true;
  } catch (e) {
    return false;
  }
}

// Helper function to format date (removes time portion)
String _formatDate(String dateString) {
  try {
    DateTime date = DateTime.parse(dateString);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  } catch (e) {
    return dateString; // Return original if parsing fails
  }
}

// Helper function to format numbers (round to 2 decimal places)
// Helper function to format numbers (round to 2 decimal places, remove .00 if whole number)
String _formatNumber(String numberString) {
  try {
    double number = double.parse(numberString);
    if (number % 1 == 0) {
      return number.toInt().toString(); // Return as integer if whole number
    } else {
      return number.toStringAsFixed(2); // Otherwise show 2 decimal places
    }
  } catch (e) {
    return numberString; // Return original if parsing fails
  }
}
Widget _buildRiskRecommendations(dynamic riskScore) {
  String riskText = riskScore?.toString().toLowerCase() ?? 'low';
  String riskLevel;
  Color riskColor;
  List<String> recommendations = [];

  switch (riskText) {
    case 'high':
      riskLevel = 'High Risk';
      riskColor = Colors.red;
      recommendations = [
        'Patient education and Oral Hygiene Instructions',
        'Oral prophylaxis',
        'Use of antimicrobial agents including plaque or Biofilm sampling and sensitivity testing',
        'Recontouring defective restoration and crown if present',
        'Advised treatment of food impaction if present',
        'Advised treatment of occlusal trauma if present',
      ];
      break;
    case 'moderate':
      riskLevel = 'Moderate Risk';
      riskColor = Colors.orange;
      recommendations = [
        'Patient education and Oral Hygiene Instructions',
        'Oral prophylaxis',
        'Use of antimicrobial agents',
        'Recontouring defective restoration and crown if present',
        'Advised treatment of food impaction if present',
        'Advised treatment of occlusal trauma if present',
      ];
      break;
    case 'low':
    default:
      riskLevel = 'Low Risk';
      riskColor = Colors.green;
      recommendations = [
        'Patient education and Oral Hygiene Instructions',
        'Oral prophylaxis',
      ];
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Treatment Recommendations:',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.blue[800],
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: riskColor),
                  ),
                  child: Text(
                    riskLevel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...recommendations.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    ],
  );
}

  // Add this function to your _PatientrecordpageState class
  void _loadPatientDataAndNavigate(
      BuildContext context, Map<String, dynamic> fullData) {
    final patientInfoProvider =
        Provider.of<PersonalinfoData>(context, listen: false);
    patientInfoProvider.updateFromMap(fullData['patientInformation']);

    final plaqueProvider = Provider.of<PlaqueIndexData>(context, listen: false);
    plaqueProvider.updateFromMap(fullData['plaqueIndexAssessment']);

    final ohiProvider = Provider.of<OHISData>(context, listen: false);
    ohiProvider.updateFromMap(fullData['oralHygieneIndexSimplified']);

    final gingivalprovider =
        Provider.of<Gingivalindexdata>(context, listen: false);
    gingivalprovider.updateFromMap(fullData['gingivalIndexAssessment']);

    final probeProvider =
        Provider.of<PeriodontalProbingProvider>(context, listen: false);
    probeProvider.updateFromMap(fullData['periodontalAssessment']);

    final assessmentProvider =
        Provider.of<PatientAssessmentData>(context, listen: false);
    assessmentProvider.updateFromMap(fullData['patientComplianceAssessment']);

    final bleedingProvider =
        Provider.of<BleedingIndexData>(context, listen: false);
    bleedingProvider.updateFromMap(fullData['bleedingIndexAssessment']);

    // Add similar lines for all your providers...

    // Then navigate to the report page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Reportpage()),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 5, left: 15, right: 15),
              child: TextField(
                controller: _searchQueryController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  hintText: 'Search patient by name or phone...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQueryController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchQueryController.clear();
                          },
                        )
                      : null,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.blue[200],
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.black54),
                ),
              ),
            ),

            // Loading/Error/Content Display
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : filteredPatients.isEmpty
                          ? Center(
                              child: Text(
                                'No patients found.',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredPatients.length,
                              itemBuilder: (context, index) {
                                final patient = filteredPatients[index];
                                return ProfileCard(
                                  patientName: patient['patientname'],
                                  phoneNumber: patient['phonenumber'],
                                  score: patient['score'],
                                  onTap: () {
                                    _showPatientDetails(
                                        context, patient['fullData']);
                                  },
                                  onEditTap: () {
                                    _loadPatientDataAndNavigate(
                                        context, patient['fullData']);
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
