import 'package:dental_new/utils/probingdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeriodontalProbingPage extends StatefulWidget {
  const PeriodontalProbingPage({super.key});

  @override
  State<PeriodontalProbingPage> createState() => _PeriodontalProbingPageState();
}

class _PeriodontalProbingPageState extends State<PeriodontalProbingPage> {
  final _missingTeethController = TextEditingController();

  final _recessionTeethController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with existing values if any
    final provider = Provider.of<PeriodontalProbingProvider>(context, listen: false);
    _missingTeethController.text = provider.missingTeeth.toString();
    _recessionTeethController.text = provider.recessionTeeth.toString();
  }

  @override
  void dispose() {
    _missingTeethController.dispose();
    _recessionTeethController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

             // Habits Section
              const Text(
                'No of teeth with probing depths ≥3-≤5mm',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
            // Probing Table
            _buildProbingTable(context),
            const SizedBox(height: 20),

            // Teeth with probing depth >=3<=5mm
            _buildProbingDepthCount(context),
            const SizedBox(height: 20),

            // Missing teeth input
            _buildMissingTeethInput(context),
            const SizedBox(height: 20),

            // Recession teeth input
            _buildRecessionTeethInput(context),
            const SizedBox(height: 20),

            // Tooth related factors
            _buildToothFactors(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProbingTable(BuildContext context) {
    final provider = Provider.of<PeriodontalProbingProvider>(context);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Upper teeth row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: provider.upperTeeth.map((tooth) {
                  return _buildToothCell(tooth, provider);
                }).toList(),
              ),
              const SizedBox(height: 8),
              
              // Upper teeth signs row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: provider.upperTeeth.map((tooth) {
                  return _buildSignCell(tooth, provider);
                }).toList(),
              ),
              const SizedBox(height: 16),
              
              // Lower teeth row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: provider.lowerTeeth.map((tooth) {
                  return _buildToothCell(tooth, provider);
                }).toList(),
              ),
              const SizedBox(height: 8),
              
              // Lower teeth signs row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: provider.lowerTeeth.map((tooth) {
                  return _buildSignCell(tooth, provider);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildToothCell(String tooth, PeriodontalProbingProvider provider) {
  return SizedBox(
    width: 35, // Match this width with the sign cell container
    child: Center( // Add Center widget for proper alignment
      child: Text(
        tooth,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget _buildSignCell(String tooth, PeriodontalProbingProvider provider) {
  final isPositive = provider.getProbingValue(tooth);
  
  return SizedBox( // Wrap with SizedBox to match tooth cell width
    width: 35, // Must match tooth cell width
    child: Center( // Center the circle within the SizedBox
      child: GestureDetector(
        onTap: () => provider.toggleProbingValue(tooth),
        child: Container(
          width: 26, // Keep your desired circle size
          height: 26,
          decoration: BoxDecoration(
            color: isPositive ? Colors.red : Colors.green[300],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              isPositive ? '+' : '-',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}  
  Widget _buildProbingDepthCount(BuildContext context) {
    final provider = Provider.of<PeriodontalProbingProvider>(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Text(
              'No. of teeth with probing depth ≥3-≤5mm:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 10),
            Text(
              provider.teethWithProbingDepth.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
   Widget _buildMissingTeethInput(BuildContext context) {
    final provider = Provider.of<PeriodontalProbingProvider>(context);
    
    return TextFormField(
      controller: _missingTeethController,
      decoration: const InputDecoration(
        labelText: 'No. of teeth missing',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        provider.missingTeeth = int.tryParse(value) ?? 0;
      },
    );
  }

  Widget _buildRecessionTeethInput(BuildContext context) {
    final provider = Provider.of<PeriodontalProbingProvider>(context);
    
    return TextFormField(
      controller: _recessionTeethController,
      decoration: const InputDecoration(
        labelText: 'No. of teeth with recession due to wasting disease',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        provider.recessionTeeth = int.tryParse(value) ?? 0;
      },
    );
  }

  Widget _buildToothFactors(BuildContext context) {
    final provider = Provider.of<PeriodontalProbingProvider>(context);
    final factors = [
      'Food impaction',
      'Malocclusion-crowding',
      'Overhanging restoration',
      'Defective Restoration',
      'Cervical enamel projection',
      'Bruxism',
      'Trauma from occlusion',
      'Subgingival restoration',
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tooth Related Factors:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: factors.map((factor) {
            return FilterChip(
              label: Text(factor),
              selected: provider.hasToothFactor(factor),
              onSelected: (selected) => provider.toggleToothFactor(factor),
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue,
            );
          }).toList(),
        ),
      ],
    );
  }
}