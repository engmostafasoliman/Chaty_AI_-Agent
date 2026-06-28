import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../repo_list/domain/entities/repo_summary_entity.dart';

class ConfidenceBadge extends StatelessWidget {
  final ConfidenceLevel confidence;
  const ConfidenceBadge({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (label, color, icon) = switch (confidence) {
      ConfidenceLevel.high => ('High confidence', AppColors.success(isDark), Icons.shield_rounded),
      ConfidenceLevel.medium => ('Medium confidence', AppColors.warning(isDark), Icons.shield_outlined),
      ConfidenceLevel.low => ('Low confidence', AppColors.danger(isDark), Icons.shield_outlined),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
