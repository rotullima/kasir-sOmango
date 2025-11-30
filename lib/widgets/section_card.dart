import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_textStyles.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing; 

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle = '',
    this.trailing, 
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      elevation: 5.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardLargeRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),

            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: AppSizes.p8),
              Text(
                subtitle,
                style: AppTextStyles.chartText.copyWith(color: AppColors.textSecondary.withOpacity(0.8)),
              ),
            ],

            const SizedBox(height: AppSizes.p16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.cardSmallRadius),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}