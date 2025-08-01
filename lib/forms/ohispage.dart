import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dental_new/utils/ohisdata.dart';

class OHISScreen extends StatefulWidget {
  const OHISScreen({super.key});

  @override
  State<OHISScreen> createState() => _OHISScreenState();
}

class _OHISScreenState extends State<OHISScreen> {
  final TextEditingController _disController = TextEditingController();
  final TextEditingController _cisController = TextEditingController();
  final TextEditingController _ohisController = TextEditingController();
  OHISData? _ohisData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newOHISData = Provider.of<OHISData>(context, listen: false);
    if (newOHISData != _ohisData) {
      _ohisData?.removeListener(_updateScores);
      newOHISData.addListener(_updateScores);
      _ohisData = newOHISData;
      _updateScores();
    }
  }

  @override
  void dispose() {
    _ohisData?.removeListener(_updateScores);
    _disController.dispose();
    _cisController.dispose();
    _ohisController.dispose();
    super.dispose();
  }

  void _updateScores() {
    if (!mounted) return;
    final ohisData = _ohisData ?? Provider.of<OHISData>(context, listen: false);
    _disController.text = ohisData.calculateDISScore().toStringAsFixed(2);
    _cisController.text = ohisData.calculateCISScore().toStringAsFixed(2);
    _ohisController.text = ohisData.calculateOHISScore().toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DI-S Section
            _buildDISSection(context),
            const SizedBox(height: 20),

            // CI-S Section
            _buildCISSection(context),
            const SizedBox(height: 16),

            // OHI-S Results Section
            _buildOHISResultsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDISSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DI-S (Debris Index Simplified)',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 260,
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _buildToothTable(context, 'DI-S'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildScoreDisplay('DI-S Score = ', _disController),
      ],
    );
  }

  Widget _buildCISSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CI-S (Calculus Index Simplified)',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 260,
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _buildToothTable(context, 'CI-S'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildScoreDisplay('CI-S Score = ', _cisController),
      ],
    );
  }

  Widget _buildOHISResultsSection(BuildContext context) {
    final ohisData = Provider.of<OHISData>(context, listen: false);
    final riskLevel = ohisData.getRiskLevel();
    Color riskColor = Colors.green;

    if (riskLevel == 'Moderate Risk') {
      riskColor = Colors.orange;
    } else if (riskLevel == 'High Risk') {
      riskColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OHI-S Results',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildScoreDisplay('OHI-S Score = ', _ohisController),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              'Risk Level: ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              riskLevel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: riskColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToothTable(BuildContext context, String indexType) {
    final ohisData = Provider.of<OHISData>(context);
    final upperTeeth = ['16', '11', '26'];
    final lowerTeeth = ['46', '31', '36'];

    return Column(
      children: [
        // Upper Teeth Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: upperTeeth.map((tooth) {
            return Column(
              children: [
                Text(
                  tooth,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                _buildInputCell(ohisData, tooth, indexType),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 10),

        // Lower Teeth Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: lowerTeeth.map((tooth) {
            return Column(
              children: [
                Text(
                  tooth,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInputCell(ohisData, tooth, indexType),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInputCell(OHISData ohisData, String toothNum, String indexType) {
    String currentValue = indexType == 'DI-S'
        ? ohisData.getDISValue(toothNum)
        : ohisData.getCISValue(toothNum);
    Color cellColor = Colors.white;

    // Set color based on value
    switch (currentValue) {
      case '1':
        cellColor = Colors.lightGreen[100]!;
        break;
      case '2':
        cellColor = Colors.orange[100]!;
        break;
      case '3':
        cellColor = Colors.red[100]!;
        break;
      default:
        cellColor = Colors.white;
    }

    return GestureDetector(
      onTap: () {
        int intValue = int.tryParse(currentValue) ?? 0;
        int nextIntValue = (intValue + 1) % 4;
        if (indexType == 'DI-S') {
          ohisData.setDISValue(toothNum, nextIntValue.toString());
        } else {
          ohisData.setCISValue(toothNum, nextIntValue.toString());
        }
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        alignment: Alignment.center,
        child: Text(
          currentValue,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              readOnly: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
