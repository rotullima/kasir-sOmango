import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '/constants/app_colors.dart';
import '/constants/app_sizes.dart';
import '/constants/app_textStyles.dart';
import '/providers/product_provider.dart';
import '/widgets/app_header.dart';
import '/widgets/app_drawer.dart';

class CreateProductScreen extends ConsumerStatefulWidget {
  const CreateProductScreen({super.key});

  @override
  ConsumerState<CreateProductScreen> createState() =>
      _CreateProductScreenState();
}

class _CreateProductScreenState extends ConsumerState<CreateProductScreen> {
  File? selectedImage;
  Uint8List? selectedImageBytes;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();

  bool isLoading = false;
  bool drawerOpen = false;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    setState(() => drawerOpen = !drawerOpen);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      setState(() {
        selectedImageBytes = bytes;
        if (!kIsWeb) {
          selectedImage = File(result.path);
        }
      });
    }
  }

  Future<void> saveProduct() async {
    if (nameController.text.isEmpty) {
      _showError("Nama produk tidak boleh kosong.");
      return;
    }

    if (priceController.text.isEmpty) {
      _showError("Harga produk tidak boleh kosong.");
      return;
    }

    final parsedPrice = double.tryParse(priceController.text);
    if (parsedPrice == null) {
      _showError("Harga harus berupa angka.");
      return;
    }

    if (categoryController.text.isEmpty) {
      _showError("Kategori produk tidak boleh kosong.");
      return;
    }

    setState(() => isLoading = true);

    try {
      String? uploadedUrl;

      if (selectedImageBytes != null) {
        final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
        uploadedUrl = await ref
            .read(productServiceProvider)
            .uploadProductImage(selectedImageBytes!, fileName);
      }

      await ref
          .read(productsProvider.notifier)
          .addProduct(
            nama: nameController.text,
            harga: parsedPrice,
            kategori: categoryController.text,
            gambar: uploadedUrl,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil ditambahkan')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p16,
                    vertical: AppSizes.p16,
                  ),
                  child: AppHeader(
                    title: "PRODUK > TAMBAH PRODUK",
                    onToggle: toggleDrawer,
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.p16),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                          AppSizes.cardLargeRadius,
                        ),
                        boxShadow: [AppSizes.shadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: pickImage,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    border: Border.all(
                                      color: AppColors.background,
                                      width: 4,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.cardSmallRadius,
                                    ),
                                    child: selectedImageBytes != null
                                        ? Image.memory(
                                            selectedImageBytes!,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 140,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                                const SizedBox(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "tambahkan gambar produk",
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.upload,
                                        size: 20,
                                        color: AppColors.textPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          buildInputField(
                            controller: nameController,
                            hint: "masukkan nama produk",
                            icon: Icons.edit,
                          ),
                          const SizedBox(height: 20),

                          buildInputField(
                            controller: priceController,
                            hint: "masukkan harga produk",
                            icon: Icons.edit,
                            keyboard: TextInputType.number,
                          ),
                          const SizedBox(height: 20),

                          buildInputField(
                            controller: categoryController,
                            hint: "masukkan kategori produk",
                            icon: Icons.edit,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  width: width < 500 ? width * 0.9 : width * 0.5,
                  margin: const EdgeInsets.only(bottom: 20, top: 10),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [AppSizes.shadow],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.close, color: Colors.red),
                        label: const Text(
                          "Kembali",
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ),

                      ElevatedButton.icon(
                        onPressed: isLoading ? null : saveProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.green,
                                ),
                              )
                            : const Icon(Icons.check, color: Colors.green),
                        label: Text(
                          isLoading ? "Menyimpan..." : "Selesai",
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            AppDrawer(isOpen: drawerOpen, onToggle: toggleDrawer),
          ],
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppSizes.shadow],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboard,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(icon, size: 20, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}
