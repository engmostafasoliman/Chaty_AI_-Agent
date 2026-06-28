import 'package:flutter/material.dart';
import '../../../../core/constants/language_colors.dart';
import '../../../../core/theme/app_colors.dart';

class TechChip extends StatelessWidget {
  final String label;
  const TechChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = kLanguageColors[label] ?? AppColors.accent(isDark);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'monospace',
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
