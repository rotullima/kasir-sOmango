import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_textStyles.dart';
import 'dart:typed_data';

class UpdateCard extends StatelessWidget {
  final bool isStockEdit; // true = edit stok
  final String productName;
  final int currentStock;
  final double? modalPrice; 
  final double? sellingPrice;

  final String imagePath; 
  final XFile? pickedImage;
  final Uint8List? pickedImageBytes;

  final TextEditingController nameController;
  final TextEditingController priceController;

  final VoidCallback onBack;
  final VoidCallback onDone;
  final VoidCallback? onPickImage;

  final ValueChanged<String>? onProductNameChanged;
  final ValueChanged<int>? onStockChanged;
  final ValueChanged<String>? onModalPriceChanged;
  final ValueChanged<String>? onSellingPriceChanged;

  const UpdateCard({
    super.key,
    required this.isStockEdit,
    required this.productName,
    required this.currentStock,
    this.modalPrice,
    this.sellingPrice,
    required this.imagePath, 
    this.pickedImage,
    this.pickedImageBytes,
    required this.nameController,
    required this.priceController,
    required this.onBack,
    required this.onDone,
    this.onPickImage,
    this.onProductNameChanged,
    this.onStockChanged,
    this.onModalPriceChanged,
    this.onSellingPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget productImage;

    if (pickedImageBytes != null) {
      productImage = Image.memory(
        pickedImageBytes!,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      );
    } else if (pickedImage != null) {
      productImage = Image.file(
        File(pickedImage!.path),
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith("http")) {
      productImage = Image.network(
        imagePath,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith("assets/")) {
      productImage = Image.asset(
        imagePath,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      );
    } else {
      productImage = Image.asset(
        "assets/jus.png",
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      );
    }

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary, 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppSizes.shadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: productImage,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isStockEdit ? "Edit Stok Produk" : "Edit Detail Produk",
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!isStockEdit)
                      GestureDetector(
                        onTap: onPickImage,
                        child: AbsorbPointer(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: pickedImage != null
                                  ? pickedImage!.name
                                  : "Cari foto produk baru",
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Icon(
                                Icons.camera_alt,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Text(
                        "Harga modal per-item:",
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    if (isStockEdit) const SizedBox(height: 4),
                    if (isStockEdit)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Rp${modalPrice.toString().replaceAll('.', ',')},-",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildLabel("Nama Produk:"),
          const SizedBox(height: 8),
          _buildTextField(
            controller: nameController,
            onChanged: onProductNameChanged,
          ),

          const SizedBox(height: 20),

          if (isStockEdit) ...[
            _buildLabel("Stok Produk:"),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _counterBtn(
                  Icons.arrow_left,
                  () => onStockChanged?.call(currentStock - 1),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    currentStock.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _counterBtn(
                  Icons.arrow_right,
                  () => onStockChanged?.call(currentStock + 1),
                ),
              ],
            ),
          ] else ...[
            _buildLabel("Harga Produk:"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: priceController,
              onChanged: onSellingPriceChanged,
            ),
          ],

          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textSecondary,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close_rounded, color: Colors.red),
                      SizedBox(width: 6),
                      Text(
                        "Kembali",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textSecondary,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.green),
                      SizedBox(width: 6),
                      Text(
                        "Selesai",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 32, color: Colors.black87),
      ),
    );
  }
}
