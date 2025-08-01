import 'package:dental_new/utils/plaqueindexdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaqueIndexScreen extends StatefulWidget {
  const PlaqueIndexScreen({super.key});

  @override
  State<PlaqueIndexScreen> createState() => _PlaqueIndexScreenState();
}

class _PlaqueIndexScreenState extends State<PlaqueIndexScreen> {
  final TextEditingController _scoreController = TextEditingController();
  PlaqueIndexData? _plaqueData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPlaqueData = Provider.of<PlaqueIndexData>(context, listen: false);
    if (newPlaqueData != _plaqueData) {
      _plaqueData?.removeListener(_updateScore);
      newPlaqueData.addListener(_updateScore);
      _plaqueData = newPlaqueData;
      _updateScore();
    }
  }

  @override
  void dispose() {
    _plaqueData?.removeListener(_updateScore);
    _scoreController.dispose();
    super.dispose();
  }

  void _updateScore() {
    if (!mounted) return;
    final plaqueData = _plaqueData ?? Provider.of<PlaqueIndexData>(context, listen: false);
    _scoreController.text = plaqueData.calculateScore().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Full Mouth Plaque Index',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              
              // Upper Arch Table
              _buildArchTable(context, "Upper Arch", PlaqueIndexData().upperTeeth),
              const SizedBox(height: 30.0),
              
              // Lower Arch Table
              _buildArchTable(context, "Lower Arch", PlaqueIndexData().lowerTeeth),
              const SizedBox(height: 30.0),
              
              // Score Card
             Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
               child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'SCORE: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            controller: _scoreController,
                            readOnly: true,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
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
             ),
                
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArchTable(BuildContext context, String title, List<String> teeth) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildPlaqueTable(context, teeth),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildPlaqueTable(BuildContext context, List<String> teeth) {
  final plaqueData = Provider.of<PlaqueIndexData>(context);
  final String secondSurfaceLabel = 'P';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Tooth Numbers Header (unchanged)
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  'Tooth',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            ...teeth.map((toothNum) => SizedBox(
                  width: 120,
                  child: Center(
                    child: Text(
                      toothNum,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
      
      // Buccal/Labial Row (unchanged)
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 50,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Center(
                child: Text(
                  'B',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            ...teeth.expand((toothNum) => [
                  _buildInputCell(plaqueData, toothNum, 'B1', true),
                  _buildInputCell(plaqueData, toothNum, 'B2', true),
                  _buildInputCell(plaqueData, toothNum, 'B3', true),
                ]),
          ],
        ),
      ),
      
      // Palatal/Lingual Row (updated)
      Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent, // Key change - makes ripple visible
          child: Row(
            children: [
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey[300]!)),
                  color: Colors.grey[100],
                ),
                child: Center(
                  child: Text(
                    secondSurfaceLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              ...teeth.map((toothNum) => 
                _buildInputCell(plaqueData, toothNum, secondSurfaceLabel, false)),
            ],
          ),
        ),
      ),
    ],
  );
}

// Updated _buildInputCell with consistent ripple effect
Widget _buildInputCell(
    PlaqueIndexData plaqueData, String toothNum, String surface, bool isBuccal) {
  return Material(
    color: Colors.transparent, // Makes ripple effect visible
    child: InkWell(
      onTap: () {
        String currentValue = plaqueData.getPlaqueValue(toothNum, surface);
        int intValue = int.tryParse(currentValue) ?? 0;
        int nextIntValue = (intValue + 1) % 4;
        plaqueData.setPlaqueValue(toothNum, surface, nextIntValue.toString());
      },
      splashColor: Colors.blue.withOpacity(0.3), // Custom ripple color
      borderRadius: BorderRadius.zero, // Square ripple to match cells
      child: Container(
        width: isBuccal ? 40 : 120,
        height: 50,
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Center(
          child: Consumer<PlaqueIndexData>(
            builder: (context, data, child) {
              final displayValue = data.getPlaqueValue(toothNum, surface);
              return Text(
                displayValue,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: displayValue == "0" ? Colors.grey : Colors.blue,
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}}