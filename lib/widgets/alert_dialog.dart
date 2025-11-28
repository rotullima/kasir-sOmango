import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 22),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          GestureDetector(
            onTap: onCancel,
            child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red, width: 3),
            ),
            child: const Icon(Icons.close, size: 20, color: Colors.red),
            ),
          ),

          const SizedBox(width: 30),

          GestureDetector(
            onTap: onConfirm,
            child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green, width: 3),
            ),
            child: const Icon(Icons.check, size: 20, color: Colors.green),
            ),
          ),
          ],
        ),
        ],
      ),
      ),
    );
  }
}
