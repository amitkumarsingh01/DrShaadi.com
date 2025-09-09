import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/info_box.dart';

class MobileVerificationScreen extends StatefulWidget {
  const MobileVerificationScreen({super.key});

  @override
  State<MobileVerificationScreen> createState() => _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'Verify Mobile Number',
        showBackButton: true,
        onBackPressed: () {
          context.go('/family-management');
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Secure Verification Section
                const Text(
                  'Secure Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We\'ll send a verification code to your mobile number for security',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                // Mobile Number Input
                CustomTextField(
                  label: 'Mobile number',
                  hintText: 'Enter your mobile number here',
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    child: const Text(
                      '+91',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Family ID Display
                const Text(
                  'Family ID',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.yellow.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'XYZMT03',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.verified,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Security Info Box
                const InfoBox(
                  title: 'Secure & Private',
                  description: 'Your mobile number is encrypted and will only be used for account verification and security purposes',
                ),
                const Spacer(),
                // Send OTP Button
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    return CustomButton(
                      text: 'Send OTP',
                      isLoading: authController.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await authController.sendOtp(_mobileController.text);
                          
                          if (mounted) {
                            if (success) {
                              context.go('/otp-verification');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authController.errorMessage ?? 'Failed to send OTP'),
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
