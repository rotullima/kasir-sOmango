import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_textStyles.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const SectionCard({super.key, required this.title, required this.child, this.subtitle = ''});

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
            Text(
              title,
              style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.p16),
            Container(
              padding: const EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.cardSmallRadius),
              ),
              child: child,
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: AppSizes.p12),
              Text(
                subtitle,
                style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
