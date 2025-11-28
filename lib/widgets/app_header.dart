import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_textStyles.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onToggle;
  
  const AppHeader({
    super.key,
    required this.title,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_right,
          size: AppSizes.iconSmall,
          color: AppColors.textPrimary,
        ),
        onPressed: onToggle,
      ),
      title: Text(
        title, 
        style: AppTextStyles.title.copyWith(
          color: AppColors.textPrimary
        )
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}