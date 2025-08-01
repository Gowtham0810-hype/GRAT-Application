import 'package:dental_new/utils/ohisdata.dart';
import 'package:dental_new/utils/personalinfodata.dart';
import 'package:dental_new/utils/plaqueindexdata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Personalinfo extends StatefulWidget {
  const Personalinfo({super.key});

  @override
  State<Personalinfo> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<Personalinfo> with AutomaticKeepAliveClientMixin{
  bool get wantKeepAlive => true; 
  
  final _formKey = GlobalKey<FormState>();
  final _bmiController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double _bmi = 0;
  
  @override
  void initState() {
    super.initState();
    // Initialize with existing values if any
    final personalData = Provider.of<PersonalinfoData>(context, listen: false);
    _heightController.text = personalData.height ?? '';
    _weightController.text = personalData.weight ?? '';
    _calculateBMI(); // Calculate initial BMI
  }



  
  @override
  void dispose() {
    _bmiController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final personalData = Provider.of<PersonalinfoData>(context, listen: false);
    
    double? height;
    double? weight;

    try {
      height = personalData.height != null
          ? double.tryParse(personalData.height!)
          : null;
      weight = personalData.weight != null
          ? double.tryParse(personalData.weight!)
          : null;
    } catch (e) {
      height = null;
      weight = null;
    }

    if (height != null && weight != null && height > 0) {
      _bmi = weight / ((height / 100) * (height / 100));
      _bmiController.text = _bmi.toStringAsFixed(1);
    } else {
      _bmi = 0;
      _bmiController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Field
              _buildDateField(context),
              const SizedBox(height: 20),

              // Patient Name
              _buildNameField(),
              const SizedBox(height: 20),

              // Age, Height, Weight
              _buildVitalFields(),
              const SizedBox(height: 20),

              // BMI Display
              _buildBmiDisplay(),
              const SizedBox(height: 20),

              // Ethnicity
              _buildEthnicityField(),
              const SizedBox(height: 20),

              // Phone Number
              _buildPhoneNumberField(),
              const SizedBox(height: 20),

              // Education Dropdown
              _buildEducationDropdown(),
              const SizedBox(height: 20),

              // Occupation Dropdown
              _buildOccupationDropdown(),
              const SizedBox(height: 20),

              // Family Income Dropdown
              _buildFamilyIncomeDropdown(),
              const SizedBox(height: 20),

              // Visit Frequency Chips
              _buildVisitFrequencyChips(),
              const SizedBox(height: 20),

              // Family History Chips
              _buildFamilyhistoryChips(),
              const SizedBox(height: 20),

              // System Risk Factor Chips
              _buildSystemRiskFactorChips(),
              const SizedBox(height: 20),

              // Personal History Section
              const Text(
                'Personal History',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              // Brushing Habits
              _buildBrushingHabitsChips(),
              const SizedBox(height: 10),

              // Brushing Frequency
              _buildBrushingFrequencyChips(),
              const SizedBox(height: 20),

              // Drug History
              _buildDrugHistoryRadio(),
              const SizedBox(height: 30),

              // Habits Section
              const Text(
                'Habits',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              // Smoking Status
              _buildSmokingStatusChips(),
              const SizedBox(height: 10),

              // Smokeless Tobacco Status
              _buildSmokelessTobaccoChips(),
              const SizedBox(height: 10),

              // Alcohol Status
              _buildAlcoholStatusChips(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Consumer<PersonalinfoData>(
      builder: (context, provider, _) {
        return InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: provider.date ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              provider.setDate(selectedDate);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date*',
              border: OutlineInputBorder(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  provider.date == null
                      ? 'Select date'
                      : DateFormat('yyyy-MM-dd').format(provider.date!),
                ),
                Icon(Icons.calendar_today_rounded)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameField() {
    return Consumer<PersonalinfoData>(
      builder: (context, provider, _) {
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Patient Name*',
            border: OutlineInputBorder(),
          ),
          initialValue: provider.patientName,
          onChanged: provider.setPatientName,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter patient name';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildVitalFields() {
    return Row(
      children: [
        Expanded(child: _buildAgeField()),
        const SizedBox(width: 10),
        Expanded(child: _buildHeightField()),
        const SizedBox(width: 10),
        Expanded(child: _buildWeightField()),
      ],
    );
  }

  Widget _buildAgeField() {
    return Consumer<PersonalinfoData>(
      builder: (context, provider, _) {
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Age*',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          initialValue: provider.age,
          onChanged: provider.setAge,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter age';
            }
            return null;
          },
        );
      },
    );
  }

  // Update your height and weight fields to use controllers:
  Widget _buildHeightField() {
    return Consumer<PersonalinfoData>(
      builder: (context, provider, _) {
        return TextFormField(
          controller: _heightController,
          decoration: const InputDecoration(
            labelText: 'Height (cm)*',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            provider.setHeight(value);
            _calculateBMI();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter height';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildWeightField() {
    return Consumer<PersonalinfoData>(
      builder: (context, provider, _) {
        return TextFormField(
          controller: _weightController,
          decoration: const InputDecoration(
            labelText: 'Weight (kg)*',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            provider.setWeight(value);
            _calculateBMI();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter weight';
            }
            return null;
          },
        );
      },
    );
  }
  Widget _buildBmiDisplay() {
    return Row(
      children: [
        const Text(
          'BMI: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(
          width: 80,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: _bmiController,
            readOnly: true,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildEthnicityField() {
    return Consumer<PersonalinfoData>(
      builder: (context, provider, _) {
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Ethnicity',
            border: OutlineInputBorder(),
          ),
          initialValue: provider.ethnicity,
          onChanged: provider.setEthnicity,
        );
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return Consumer<PersonalinfoData>(
      builder: (context, provider, _) {
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Phone Number*',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          initialValue: provider.phoneNumber,
          onChanged: provider.setPhoneNumber,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            if (value.length < 10) {
              return 'Phone number too short';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildEducationDropdown() {
    return Consumer<PersonalinfoData>(
      builder: (context, provider, _) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Education*',
            border: const OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.education.isEmpty ? null : provider.education,
              isDense: true,
              isExpanded: true,
              items: PersonalinfoData.educationOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: provider.setEducation,
              hint: const Text('Select education level'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOccupationDropdown() {
    return Consumer<PersonalinfoData>(
      builder: (context, provider, _) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Occupation*',
            border: const OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.occupation.isEmpty ? null : provider.occupation,
              isDense: true,
              isExpanded: true,
              items: PersonalinfoData.occupationOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: provider.setOccupation,
              hint: const Text('Select occupation'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFamilyIncomeDropdown() {
    return Consumer<PersonalinfoData>(
      builder: (context, provider, _) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Family Income (per month)*',
            border: const OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value:
                  provider.familyIncome.isEmpty ? null : provider.familyIncome,
              isDense: true,
              isExpanded: true,
              items: PersonalinfoData.familyIncomeOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: provider.setFamilyIncome,
              hint: const Text('Select income range'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVisitFrequencyChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequency of Visits*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Consumer<PersonalinfoData>(
          builder: (context, provider, _) {
            return Wrap(
              spacing: 8,
              children: PersonalinfoData.visitFrequencyOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: provider.visitFrequency == option,
                  onSelected: (selected) {
                    if (selected) {
                      provider.setVisitFrequency(option);
                    }
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSystemRiskFactorChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Risk Factor',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Consumer<PersonalinfoData>(
          builder: (context, provider, _) {
            return Wrap(
              spacing: 8,
              children: PersonalinfoData.systemRiskFactorOptions.map((option) {
                return FilterChip(
                  label: Text(option),
                  selected: provider.systemRiskFactors.contains(option),
                  onSelected: (selected) {
                    provider.toggleSystemRiskFactor(option);
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBrushingHabitsChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Brushing Habits*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Consumer<PersonalinfoData>(
          builder: (context, provider, _) {
            return Wrap(
              spacing: 8,
              children: PersonalinfoData.brushingHabitsOptions.map((option) {
                return FilterChip(
                  label: Text(option),
                  selected: provider.brushingHabits.contains(option),
                  onSelected: (selected) {
                    
                      provider.toggleSbrushinghabits(option);
                    
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFamilyhistoryChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Family History*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Consumer<PersonalinfoData>(
          builder: (context, provider, _) {
            return Wrap(
              spacing: 8,
              children: PersonalinfoData.familyHistoryOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: provider.familyHistory == option,
                  onSelected: (selected) {
                    if (selected) {
                      provider.setfamilyHistory(option);
                    }
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBrushingFrequencyChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Frequency of Brushing/Flossing*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Consumer<PersonalinfoData>(
          builder: (context, provider, _) {
            return Wrap(
              spacing: 8,
              children: PersonalinfoData.brushingFrequencyOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: provider.brushingFrequency == option,
                  onSelected: (selected) {
                    if (selected) {
                      provider.setBrushingFrequency(option);
                    }
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDrugHistoryRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Drug History*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 6),
        Consumer<PersonalinfoData>(
          builder: (context, provider, _) {
            return Row(
              children: PersonalinfoData.drugHistoryOptions.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Radio<String>(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: option,
                          groupValue: provider.drugHistory,
                          onChanged: (value) {
                            provider.setDrugHistory(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(option),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSmokingStatusChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Smoking Status*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Consumer<PersonalinfoData>(
          builder: (context, provider, _) {
            return Wrap(
              spacing: 8,
              children: PersonalinfoData.smokingStatusOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: provider.smokingStatus == option,
                  onSelected: (selected) {
                    if (selected) {
                      provider.setSmokingStatus(option);
                    }
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSmokelessTobaccoChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Smokeless Tobacco Status*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Consumer<PersonalinfoData>(
          builder: (context, provider, _) {
            return Wrap(
              spacing: 8,
              children: PersonalinfoData.smokelessTobaccoOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: provider.smokelessTobaccoStatus == option,
                  onSelected: (selected) {
                    if (selected) {
                      provider.setSmokelessTobaccoStatus(option);
                    }
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAlcoholStatusChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Alcohol Status*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Consumer<PersonalinfoData>(
          builder: (context, provider, _) {
            return Wrap(
              spacing: 8,
              children: PersonalinfoData.alcoholStatusOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: provider.alcoholStatus == option,
                  onSelected: (selected) {
                    if (selected) {
                      provider.setAlcoholStatus(option);
                    }
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}