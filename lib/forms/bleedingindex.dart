import 'package:dental_new/components/bleedingcell.dart';
import 'package:dental_new/utils/bleedingindexdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bleedingindex extends StatelessWidget {
  const Bleedingindex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Upper Arch Card
            Column(
                  children: [
                    const Text(
                      'UPPER ARCH',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBleedingTable(context, true),
                  ],
                ),
            SizedBox(height: 15,),
            // Lower Arch Card
            Column(
                  children: [
                    const Text(
                      'LOWER ARCH',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBleedingTable(context, false),
                  ],
                ),
             
            SizedBox(height: 10,),
            // Score Card
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildScoreDisplay(context),
              ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildBleedingTable(BuildContext context, bool isUpperArch) {
    final bleedingData = Provider.of<BleedingIndexData>(context);
    final teeth = isUpperArch ? bleedingData.upperTeeth : bleedingData.lowerTeeth;
    final surfaceLabel = isUpperArch ? 'P' : 'L';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // Tooth numbers header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Row(
                children: [
                   // Space for B/L label
                  ...teeth.map((tooth) => SizedBox(
                        width: 74,
                        child: Center(
                          child: Text(
                            tooth,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )),
                  // Space for P/L label
                ],
              ),
            ),
            
            // Bleeding cells row
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  // B/L label
                  Container(
                    width: 40,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.3))),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        ' ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  
                  // Bleeding cells
                  ...teeth.map((tooth) => Container(
                    margin: EdgeInsets.only(right: 13,bottom:15 ),
                    child: BleedingCell(
                          top: bleedingData.getBleedingValue(tooth, 1),
                          left: bleedingData.getBleedingValue(tooth, 2),
                          right: bleedingData.getBleedingValue(tooth, 3),
                          bottom: bleedingData.getBleedingValue(tooth, 4),
                          onTapped: (region) => bleedingData.toggleBleedingValue(tooth, region),
                        ),
                  )),
                  
                  // P/L label
                  Container(
                    width: 40,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.grey.withOpacity(0.3))),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(BuildContext context) {
    return Consumer<BleedingIndexData>(
      builder: (context, bleedingData, child) {
        final score = bleedingData.calculateScore();
        final percentage = bleedingData.calculatePercentage();
        
        return Column(
          children: [
            const Text(
              'BLEEDING INDEX RESULTS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text(
                      'SCORE',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Center(
                        child: Text(
                          '$score',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'PERCENTAGE',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Center(
                        child: Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}