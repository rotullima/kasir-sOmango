import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class StockCard extends StatelessWidget {
  final String name;
  final dynamic displayValue;        // baru: bisa int stock atau price
  final String image;
  final VoidCallback? onEdit;
  final VoidCallback? onDetail;
  final bool showActions;            // baru: buat sembunyiin icon edit/detail

  const StockCard({
    super.key,
    required this.name,
    required this.displayValue,
    required this.image,
    this.onEdit,
    this.onDetail,
    this.showActions = true,         // default true (buat stok), false buat kasir
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppSizes.shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(),
              if (showActions) ...[          // hanya muncul kalau showActions = true
                Column(
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: onDetail,
                      child: const Icon(Icons.info_outline, size: 20, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            displayValue is int && displayValue >= 1000
                ? "Rp${displayValue.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')},-"
                : "stok: $displayValue",
            style: TextStyle(
              fontSize: 12,
              fontWeight: displayValue is int && displayValue >= 1000 ? FontWeight.bold : FontWeight.normal,
              color: displayValue is int && displayValue >= 1000 ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}