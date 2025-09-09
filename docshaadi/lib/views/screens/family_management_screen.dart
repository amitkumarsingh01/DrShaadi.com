import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/family_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/info_box.dart';

class FamilyManagementScreen extends StatefulWidget {
  const FamilyManagementScreen({super.key});

  @override
  State<FamilyManagementScreen> createState() => _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends State<FamilyManagementScreen> {
  final TextEditingController _familyIdController = TextEditingController();
  bool _isJoinMode = true;
  String? _generatedFamilyId;

  @override
  void initState() {
    super.initState();
    _generatedFamilyId = context.read<FamilyController>().generateFamilyId();
  }

  @override
  void dispose() {
    _familyIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'DrShaadi.com',
        showBackButton: true,
        onBackPressed: () {
          context.go('/');
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Main Title
              const Text(
                'Manage Family profiles',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create a Family ID to manage multiple profiles or join existing one',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              // Segmented Control
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isJoinMode = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isJoinMode ? AppTheme.primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Enter Family ID',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isJoinMode ? Colors.white : AppTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isJoinMode = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isJoinMode ? AppTheme.primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Create New ID',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !_isJoinMode ? Colors.white : AppTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Content based on mode
              if (_isJoinMode) ...[
                // Join Family Section
                const Text(
                  'Join Your Family',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your Family ID to connect with your family members',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Family ID',
                  hintText: 'Enter your Family ID here',
                  controller: _familyIdController,
                  isRequired: true,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ask your family member for the Family ID they Received!',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                // Benefits Info Box
                const InfoBox(
                  title: 'Benefits of Family ID:',
                  bulletPoints: [
                    'Share profile management with family',
                    'Get family support in finding matches',
                    'Enhanced Trust',
                  ],
                ),
              ] else ...[
                // Create New Family Section
                const Text(
                  'Your Family ID',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                // Family ID Display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _generatedFamilyId ?? 'XYZMT03',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Copy to clipboard
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Family ID copied to clipboard'),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.copy,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Share this ID with your family members to connect their profiles',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                // Share Button
                Row(
                  children: [
                    const Icon(
                      Icons.share,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // Share functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Share functionality would be implemented'),
                          ),
                        );
                      },
                      child: const Text(
                        'Share Family ID',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // How to use Info Box
                const InfoBox(
                  title: 'How to use Family ID?:',
                  bulletPoints: [
                    'Complete your profile creation process',
                    'Share this Family ID with your family members',
                    'They can use it to select the best partner',
                  ],
                ),
              ],
              const Spacer(),
              // Continue Button
              Consumer<FamilyController>(
                builder: (context, familyController, child) {
                  return CustomButton(
                    text: 'Continue',
                    isLoading: familyController.isLoading,
                    onPressed: () async {
                      if (_isJoinMode) {
                        if (_familyIdController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a Family ID'),
                            ),
                          );
                          return;
                        }
                        
                        final success = await familyController.joinFamily(
                          _familyIdController.text,
                          'current_user_id', // This should come from auth
                        );
                        
                        if (mounted) {
                          if (success) {
                            context.go('/mobile-verification');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(familyController.errorMessage ?? 'Failed to join family'),
                              ),
                            );
                          }
                        }
                      } else {
                        final success = await familyController.createFamily('current_user_id');
                        
                        if (mounted) {
                          if (success) {
                            context.go('/mobile-verification');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(familyController.errorMessage ?? 'Failed to create family'),
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
    );
  }
}
