import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _resendTimer = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 30;
    _canResend = false;
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendTimer--;
          if (_resendTimer <= 0) {
            _canResend = true;
          }
        });
        return _resendTimer > 0;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'Verify Mobile Number',
        showBackButton: true,
        onBackPressed: () {
          context.go('/mobile-verification');
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Instruction Text
              const Text(
                'Enter the 4-digit code sent to',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '+91 9258258866',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 40),
              // OTP Input Fields
              PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 60,
                  fieldWidth: 60,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.grey[100],
                  selectedFillColor: Colors.white,
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: AppTheme.borderColor,
                  selectedColor: AppTheme.primaryColor,
                ),
                enableActiveFill: true,
                onCompleted: (value) {
                  // Auto-verify when OTP is complete
                  _verifyOtp(value);
                },
                onChanged: (value) {
                  // Handle OTP input changes
                },
              ),
              const SizedBox(height: 24),
              // Resend Timer/Button
              Center(
                child: _canResend
                    ? GestureDetector(
                        onTap: () async {
                          final authController = context.read<AuthController>();
                          final success = await authController.resendOtp();
                          
                          if (mounted) {
                            if (success) {
                              _startResendTimer();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('OTP sent successfully'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authController.errorMessage ?? 'Failed to resend OTP'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        'Resend OTP in ${_resendTimer}s',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              // Change Number Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    context.go('/mobile-verification');
                  },
                  child: const Text(
                    'Wrong number? Change it',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Verify OTP Button
              Consumer<AuthController>(
                builder: (context, authController, child) {
                  return CustomButton(
                    text: 'Verify OTP',
                    isLoading: authController.isLoading,
                    onPressed: _otpController.text.length == 4 ? () => _verifyOtp(_otpController.text) : null,
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

  Future<void> _verifyOtp(String otp) async {
    final authController = context.read<AuthController>();
    final success = await authController.verifyOtp(otp);
    
    if (mounted) {
      if (success) {
        context.go('/profile-setup');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.errorMessage ?? 'Invalid OTP'),
          ),
        );
      }
    }
  }
}
