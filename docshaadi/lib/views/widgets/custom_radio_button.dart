import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;

  const CustomRadioButton({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    required this.title,
    this.subtitle,
    this.leading,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    
    return GestureDetector(
      onTap: enabled ? () => onChanged?.call(value) : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: enabled ? AppTheme.textPrimary : AppTheme.textLight,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: enabled ? AppTheme.textSecondary : AppTheme.textLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: enabled ? onChanged : null,
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
