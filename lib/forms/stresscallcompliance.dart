import 'package:dental_new/utils/stresscallandcomplaincedata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientAssessmentScreen extends StatefulWidget {
  const PatientAssessmentScreen({super.key});

  @override
  State<PatientAssessmentScreen> createState() =>
      _PatientAssessmentScreenState();
}

class _PatientAssessmentScreenState extends State<PatientAssessmentScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildComplianceSection(context),
            const SizedBox(height: 32),
            _buildStressAssessmentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceSection(BuildContext context) {
    final assessmentData = Provider.of<PatientAssessmentData>(context);
    final complianceOptions = {
      0: 'Patient completely refuses treatment',
      1: 'Patient reluctantly refuses treatment',
      2: 'Patient reluctantly accepts treatment',
      3: 'Patient occasionally refuses treatment',
      4: 'Patient passively accepts treatment',
      5: 'Patient moderately participates in treatment',
      6: 'Patient actively participates in treatment',
    };
    final scorevalue = assessmentData.complianceRating + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PATIENT COMPLIANCE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'CLINICIAN RATING OF COMPLIANCE SCALE (CRCS):',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: complianceOptions.entries.map((entry) {
            return RadioListTile<int>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: assessmentData.complianceRating,
              onChanged: (value) {
                assessmentData.setComplianceRating(value!);
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SELECTED SCORE:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                scorevalue.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStressAssessmentSection(BuildContext context) {
    final assessmentData = Provider.of<PatientAssessmentData>(context);
    final questions = [
      'In the last month, how often have you been upset because of something that happened unexpectedly?',
      'In the last month, how often have you felt that you were unable to control the important things in your life?',
      'In the last month, how often have you felt nervous and stressed?',
      'In the last month, how often have you felt confident about your ability to handle your personal problems?',
      'In the last month, how often have you felt that things were going your way?',
      'In the last month, how often have you found that you could not cope with all the things that you had to do?',
      'In the last month, how often have you been able to control irritations in your life?',
      'In the last month, how often have you felt that you were on top of things?',
      'In the last month, how often have you been angered because of things that happened that were outside of your control?',
      'In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STRESS ASSESSMENT',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please rate how often you experienced the following in the last month:',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(questions.length, (index) {
          return _buildStressQuestion(
            context,
            question: questions[index],
            index: index,
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL STRESS SCORE:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                assessmentData.totalStressScore.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getStressScoreColor(assessmentData.totalStressScore),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getStressInterpretation(assessmentData.totalStressScore),
          style: const TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildStressQuestion(BuildContext context,
      {required String question, required int index}) {
    final assessmentData = Provider.of<PatientAssessmentData>(context);
    final isReverseScored =
        [3, 4, 6, 7].contains(index); // Questions 4,5,7,8 (0-based)
    final labels = [
      'Never',
      'Almost Never',
      'Sometimes',
      'Fairly Often',
      'Very Often'
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. $question',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: assessmentData.stressAnswers[index].toDouble(),
            min: 0,
            max: 4,
            divisions: 4,
            label: labels[assessmentData.stressAnswers[index]],
            onChanged: (value) {
              assessmentData.setStressAnswer(index, value.toInt());
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (i) {
                return Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 10,
                    color: assessmentData.stressAnswers[index] == i
                        ? Colors.blue
                        : Colors.grey,
                    fontWeight: assessmentData.stressAnswers[index] == i
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStressScoreColor(int score) {
    if (score < 14) return Colors.green;
    if (score < 27) return Colors.orange;
    return Colors.red;
  }

  String _getStressInterpretation(int score) {
    if (score < 14) return 'Low stress level';
    if (score < 27) return 'Moderate stress level';
    return 'High stress level - Consider referral to stress management';
  }
}
