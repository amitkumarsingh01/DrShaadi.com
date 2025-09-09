import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CustomProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double? height;

  const CustomProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;
    
    return Column(
      children: [
        Text(
          'Step $currentStep of $totalSteps',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height ?? 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.grey[300],
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
