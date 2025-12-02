import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class StockCard extends StatelessWidget {
  final String name;
  final dynamic displayValue;
  final String image;
  final VoidCallback? onEdit;
  final VoidCallback? onDetail;
  final bool showActions;

  const StockCard({
    super.key,
    required this.name,
    required this.displayValue,
    required this.image,
    this.onEdit,
    this.onDetail,
    this.showActions = true,
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
                child: _buildImage(),
              ),
              const Spacer(),
              if (showActions) ...[
                Column(
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: onDetail,
                      child: const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displayValue is int && displayValue >= 1000
                ? "Rp${displayValue.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')},-"
                : "stok: $displayValue",
            style: TextStyle(
              fontSize: 12,
              fontWeight: displayValue is int && displayValue >= 1000
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: displayValue is int && displayValue >= 1000
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final isNetworkImage =
        image.startsWith('http://') || image.startsWith('https://');
    final isAssetImage = image.startsWith('assets/');

    if (isNetworkImage) {
      return Image.network(
        image,
        height: 70,
        width: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error loading image: $error');
          print('   URL: $image');
          return _buildPlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 70,
            width: 70,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    } else if (isAssetImage) {
      return Image.asset(
        image,
        height: 70,
        width: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error loading asset: $error');
          return _buildPlaceholder();
        },
      );
    } else {
      print('⚠️ Invalid image path: $image');
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 35,
        color: Colors.grey[400],
      ),
    );
  }
}
