
import 'package:dental_new/utils/gingivalindexdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GingivalIndexScreen extends StatefulWidget {
  const GingivalIndexScreen({super.key});

  @override
  State<GingivalIndexScreen> createState() => _GingivalIndexScreenState();
}

class _GingivalIndexScreenState extends State<GingivalIndexScreen> {
  final TextEditingController _scoreController = TextEditingController();
  Gingivalindexdata? _gingivalData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newgingivalData = Provider.of<Gingivalindexdata>(context, listen: false);
    if (newgingivalData != _gingivalData) {
      _gingivalData?.removeListener(_updateScore);
      newgingivalData.addListener(_updateScore);
      _gingivalData = newgingivalData;
      _updateScore();
    }
  }

  @override
  void dispose() {
    _gingivalData?.removeListener(_updateScore);
    _scoreController.dispose();
    super.dispose();
  }

  void _updateScore() {
    if (!mounted) return;
    final gingivalData = _gingivalData ?? Provider.of<Gingivalindexdata>(context, listen: false);
    _scoreController.text = gingivalData.calculateScore().toString();
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
                'Full Mouth Gingival Index',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              
              // Upper Arch Table
              _buildArchTable(context, "Upper Arch", Gingivalindexdata().upperTeeth),
              const SizedBox(height: 30.0),
              
              // Lower Arch Table
              _buildArchTable(context, "Lower Arch", Gingivalindexdata().lowerTeeth),
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
              child: _buildgingivalTable(context, teeth),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildgingivalTable(BuildContext context, List<String> teeth) {
  final plaqueData = Provider.of<Gingivalindexdata>(context);
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
    Gingivalindexdata plaqueData, String toothNum, String surface, bool isBuccal) {
  return Material(
    color: Colors.transparent, // Makes ripple effect visible
    child: InkWell(
      onTap: () {
        String currentValue = plaqueData.getgingivalValue(toothNum, surface);
        int intValue = int.tryParse(currentValue) ?? 0;
        int nextIntValue = (intValue + 1) % 4;
        plaqueData.setgingivalValue(toothNum, surface, nextIntValue.toString());
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
          child: Consumer<Gingivalindexdata>(
            builder: (context, data, child) {
              final displayValue = data.getgingivalValue(toothNum, surface);
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