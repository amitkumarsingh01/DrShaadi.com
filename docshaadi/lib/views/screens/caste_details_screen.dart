import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/profile_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_radio_button.dart';

class CasteDetailsScreen extends StatefulWidget {
  const CasteDetailsScreen({super.key});

  @override
  State<CasteDetailsScreen> createState() => _CasteDetailsScreenState();
}

class _CasteDetailsScreenState extends State<CasteDetailsScreen> {
  String? _caste;
  String? _subcaste;
  bool _isNotParticularAboutCaste = false;

  final List<String> _castes = [
    'Naidu',
    'Reddy',
    'Kamma',
    'Kapu',
    'Brahmin',
    'Kshatriya',
    'Vaishya',
    'Shudra',
    'Other',
  ];

  final List<String> _subcastes = [
    'Telugu',
    'Tamil',
    'Kannada',
    'Malayalam',
    'Other',
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
      _caste = profileData.caste;
      _subcaste = profileData.subcaste;
      _isNotParticularAboutCaste = profileData.isNotParticularAboutCaste;
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
                'Caste Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              // Caste Dropdown
              CustomDropdown<String>(
                label: 'Caste',
                value: _caste,
                hintText: 'EX: Naidu',
                isRequired: !_isNotParticularAboutCaste,
                enabled: !_isNotParticularAboutCaste,
                items: _castes.map((caste) => DropdownMenuItem(
                  value: caste,
                  child: Text(caste),
                )).toList(),
                onChanged: _isNotParticularAboutCaste ? null : (value) {
                  setState(() {
                    _caste = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Subcaste Dropdown
              CustomDropdown<String>(
                label: 'Subcaste',
                value: _subcaste,
                hintText: 'EX: Name of the subcaste',
                isRequired: !_isNotParticularAboutCaste,
                enabled: !_isNotParticularAboutCaste,
                items: _subcastes.map((subcaste) => DropdownMenuItem(
                  value: subcaste,
                  child: Text(subcaste),
                )).toList(),
                onChanged: _isNotParticularAboutCaste ? null : (value) {
                  setState(() {
                    _subcaste = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Not Particular About Caste Radio Button
              CustomRadioButton<bool>(
                value: true,
                groupValue: _isNotParticularAboutCaste,
                onChanged: (value) {
                  setState(() {
                    _isNotParticularAboutCaste = value!;
                    if (_isNotParticularAboutCaste) {
                      _caste = null;
                      _subcaste = null;
                    }
                  });
                },
                title: 'Not Particular about the caste',
              ),
              const Spacer(),
              // Continue Button
              Consumer<ProfileController>(
                builder: (context, profileController, child) {
                  return CustomButton(
                    text: 'Continue',
                    isLoading: profileController.isLoading,
                    onPressed: () async {
                      final success = await profileController.updateCasteDetails(
                        caste: _caste,
                        subcaste: _subcaste,
                        isNotParticularAboutCaste: _isNotParticularAboutCaste,
                      );
                      
                      if (mounted) {
                        if (success) {
                          profileController.nextStep();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(profileController.errorMessage ?? 'Failed to save caste details'),
                            ),
                          );
                        }
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
