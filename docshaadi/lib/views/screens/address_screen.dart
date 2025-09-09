import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/profile_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _pincodeController = TextEditingController();
  String? _grewUpIn;
  String? _residencyStatus;

  final List<String> _cities = [
    'Bengaluru',
    'Mumbai',
    'Delhi',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Surat',
  ];

  final List<String> _residencyStatuses = [
    'NRI',
    'Indian Citizen',
    'PIO',
    'OCI',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    final profileController = context.read<ProfileController>();
    final profileData = profileController.profileData;
    
    if (profileData != null) {
      _locationController.text = profileData.location ?? '';
      _pincodeController.text = profileData.pincode ?? '';
      _grewUpIn = profileData.grewUpIn;
      _residencyStatus = profileData.residencyStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                // Location and Pincode Row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Location',
                        hintText: 'EX: Address line 1',
                        controller: _locationController,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your location';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Pincode',
                        hintText: 'EX: 56009',
                        controller: _pincodeController,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter pincode';
                          }
                          if (value.length != 6) {
                            return 'Please enter valid 6-digit pincode';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Grew Up In Dropdown
                CustomDropdown<String>(
                  label: 'Grew Up In',
                  value: _grewUpIn,
                  hintText: 'EX: Bengaluru',
                  isRequired: true,
                  items: _cities.map((city) => DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _grewUpIn = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select where you grew up';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Residency Status Dropdown
                CustomDropdown<String>(
                  label: 'Residency Status',
                  value: _residencyStatus,
                  hintText: 'EX: NRI',
                  isRequired: true,
                  items: _residencyStatuses.map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _residencyStatus = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your residency status';
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
                        if (_formKey.currentState!.validate()) {
                          final success = await profileController.updateAddress(
                            location: _locationController.text,
                            pincode: _pincodeController.text,
                            grewUpIn: _grewUpIn!,
                            residencyStatus: _residencyStatus!,
                          );
                          
                          if (mounted) {
                            if (success) {
                              profileController.nextStep();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(profileController.errorMessage ?? 'Failed to save address'),
                                ),
                              );
                            }
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
      ),
    );
  }
}
