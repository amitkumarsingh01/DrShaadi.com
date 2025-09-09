import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/profile_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown.dart';

class MaritalInfoScreen extends StatefulWidget {
  const MaritalInfoScreen({super.key});

  @override
  State<MaritalInfoScreen> createState() => _MaritalInfoScreenState();
}

class _MaritalInfoScreenState extends State<MaritalInfoScreen> {
  String? _maritalStatus;
  String? _height;
  String? _diet;

  final List<String> _maritalStatuses = [
    'Never Married',
    'Divorced',
    'Widowed',
    'Separated',
  ];

  final List<String> _heights = [
    '150cm',
    '155cm',
    '160cm',
    '165cm',
    '170cm',
    '175cm',
    '180cm',
    '185cm',
    '190cm',
    '195cm',
    '200cm',
  ];

  final List<String> _diets = [
    'VEGETARIAN',
    'NON-VEG',
    'EGGITARIAN',
    'JAIN',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final profileController = context.read<ProfileController>();
    final profileData = profileController.profileData;
    
    if (profileData != null) {
      _maritalStatus = profileData.maritalStatus;
      _height = profileData.height;
      _diet = profileData.diet;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Title
              const Text(
                'Marital Info',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              // Marital Status Dropdown
              CustomDropdown<String>(
                label: 'Marital Status',
                value: _maritalStatus,
                hintText: 'Select',
                isRequired: true,
                items: _maritalStatuses.map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _maritalStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your marital status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Height Dropdown
              CustomDropdown<String>(
                label: 'Height',
                value: _height,
                hintText: 'EX: 180cm',
                isRequired: true,
                items: _heights.map((height) => DropdownMenuItem(
                  value: height,
                  child: Text(height),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _height = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your height';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Diet Dropdown
              CustomDropdown<String>(
                label: 'Diet',
                value: _diet,
                hintText: 'EX: NON-VEG',
                isRequired: true,
                items: _diets.map((diet) => DropdownMenuItem(
                  value: diet,
                  child: Text(diet),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _diet = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your diet preference';
                  }
                  return null;
                },
              ),
              const Spacer(),
              // Continue Button
              Consumer<ProfileController>(
                builder: (context, profileController, child) {
                  return CustomButton(
                    text: 'Continue',
                    isLoading: profileController.isLoading,
                    onPressed: () async {
                      if (_maritalStatus != null && _height != null && _diet != null) {
                        final success = await profileController.updateMaritalInfo(
                          maritalStatus: _maritalStatus!,
                          height: _height!,
                          diet: _diet!,
                        );
                        
                        if (mounted) {
                          if (success) {
                            // Navigate to next step or complete profile
                            profileController.nextStep();
                            // For now, just show completion message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile setup completed!'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(profileController.errorMessage ?? 'Failed to save marital info'),
                              ),
                            );
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all required fields'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
