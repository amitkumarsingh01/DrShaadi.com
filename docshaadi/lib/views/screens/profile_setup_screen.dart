import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/profile_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/progress_indicator.dart';
import 'address_screen.dart';
import 'caste_details_screen.dart';
import 'marital_info_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 5; // Starting from step 5 (Address)

  final List<Widget> _screens = [
    const AddressScreen(),
    const CasteDetailsScreen(),
    const MaritalInfoScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Listen to profile controller step changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().addListener(_onStepChanged);
    });
  }

  @override
  void dispose() {
    context.read<ProfileController>().removeListener(_onStepChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onStepChanged() {
    final profileController = context.read<ProfileController>();
    if (profileController.currentStep != _currentStep) {
      setState(() {
        _currentStep = profileController.currentStep;
      });
      
      // Navigate to the appropriate screen
      if (_currentStep >= 5 && _currentStep <= 7) {
        _pageController.animateToPage(
          _currentStep - 5,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'Profile Setup',
        showBackButton: true,
        onBackPressed: () {
          if (_currentStep > 5) {
            context.read<ProfileController>().previousStep();
          } else {
            context.go('/otp-verification');
          }
        },
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: CustomProgressIndicator(
              currentStep: _currentStep,
              totalSteps: 9,
            ),
          ),
          // Screen Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}
