import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_product.dart';
import 'dart:ui';
import 'dart:typed_data';
import '/widgets/alert_dialog.dart';
import '/constants/app_colors.dart';
import '/constants/app_sizes.dart';
import '/constants/app_textStyles.dart';
import '/widgets/update_card.dart';
import '/widgets/app_header.dart';
import '/widgets/app_drawer.dart';
import '/providers/product_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  bool isOpen = false;
  bool showFilterPopup = false;
  Map<String, dynamic>? produkDihapus;
  Map<String, dynamic>? productUpdate;
  String? editingName;
  double? editingPrice;
  XFile? editingImage;
  Uint8List? editingImageBytes;

  final ImagePicker picker = ImagePicker();
  final TextEditingController _searchController = TextEditingController();
  late TextEditingController nameController;
  late TextEditingController priceController;

  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    _searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    setState(() => isOpen = !isOpen);
  }

  Future<void> pickImage() async {
    final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        editingImage = photo;
        editingImageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final filteredProducts = ref.watch(filteredProductsProvider);
    final selectedFilter = ref.watch(filterCategoryProvider);

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
                  child: AppHeader(title: 'PRODUK', onToggle: toggleDrawer),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.p16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 45,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: "cari...",
                                    hintStyle: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.search,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.p12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showFilterPopup = !showFilterPopup;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.p8),
                          child: const Icon(
                            Icons.filter_alt_outlined,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.sectionGap),

                Expanded(
                  child: filteredProducts.when(
                    data: (products) {
                      if (products.isEmpty) {
                        return const Center(child: Text("Tidak ada produk"));
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await ref
                              .read(productsProvider.notifier)
                              .loadProducts();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            left: AppSizes.p16,
                            right: AppSizes.p16,
                            bottom: 120,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return _buildProductItem(products[index]);
                          },
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: $error'),
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(productsProvider.notifier)
                                  .loadProducts();
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            AppDrawer(isOpen: isOpen, onToggle: toggleDrawer),

            if (showFilterPopup)
              Positioned(
                top: 140,
                right: width < 500 ? 20 : width * 0.15,
                child: _filterPopup(selectedFilter),
              ),

            if (produkDihapus != null)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    alignment: Alignment.center,
                    child: ConfirmDialog(
                      title: "Apakah yakin menghapus produk ini?",
                      onCancel: () => setState(() => produkDihapus = null),
                      onConfirm: () async {
                        try {
                          await ref
                              .read(productsProvider.notifier)
                              .deleteProduct(produkDihapus!['produk_id']);
                          setState(() => produkDihapus = null);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Produk berhasil dihapus'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Gagal menghapus: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),

            if (productUpdate != null)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    alignment: Alignment.center,
                    child: UpdateCard(
                      isStockEdit: false,
                      productName: productUpdate!['nama_produk'],
                      sellingPrice: (productUpdate!['harga'] as num).toDouble(),
                      currentStock: productUpdate!['stok'],
                      imagePath: productUpdate!['gambar_produk'],
                      pickedImage: editingImage,
                      pickedImageBytes: editingImageBytes,
                      nameController: nameController,
                      priceController: priceController,
                      onBack: () => setState(() => productUpdate = null),
                      onDone: () async {
                        try {
                          String? uploadedUrl;

                          if (editingImageBytes != null) {
                            final fileName =
                                "${DateTime.now().millisecondsSinceEpoch}.jpg";
                            uploadedUrl = await ref
                                .read(productServiceProvider)
                                .uploadProductImage(
                                  editingImageBytes!,
                                  fileName,
                                );
                          }

                          await ref
                              .read(productsProvider.notifier)
                              .updateProduct(
                                produkId: productUpdate!['produk_id'],
                                nama: editingName,
                                harga: editingPrice,
                                gambar: uploadedUrl,
                              );

                          setState(() => productUpdate = null);

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Produk berhasil diupdate'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Gagal update: $e')),
                            );
                          }
                        }
                      },
                      onPickImage: pickImage,
                      onProductNameChanged: (newName) {
                        setState(() => editingName = newName);
                      },
                      onSellingPriceChanged: (newPrice) {
                        setState(() {
                          editingPrice = newPrice.isEmpty
                              ? null
                              : double.tryParse(newPrice);
                        });
                      },
                    ),
                  ),
                ),
              ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  top: 10,
                ),
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
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateProductScreen(),
                          ),
                        );

                        if (result == true) {
                          ref.read(productsProvider.notifier).loadProducts();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(Icons.add, color: AppColors.textPrimary),
                      label: const Text(
                        "Tambah Produk",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // routing nantiii
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(
                        Icons.list,
                        color: AppColors.textPrimary,
                      ),
                      label: const Text(
                        "Manajemen Stok",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.p12),
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardSmallRadius),
        boxShadow: [AppSizes.shadow],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.cardSmallRadius),
            child: item['gambar_produk'] != null
                ? Image.network(
                    item['gambar_produk'],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  )
                : Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
          ),
          const SizedBox(width: AppSizes.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['nama_produk'] ?? 'Produk',
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "harga: Rp.${item['harga']},-",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  "stok: ${item['stok']}",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  nameController.text = item['nama_produk'] ?? '';
                  priceController.text = item['harga'].toString();
                  setState(() {
                    productUpdate = item;
                    editingName = item['nama_produk'] as String?;
                    editingPrice = (item['harga'] as num).toDouble();
                    editingImage = null;
                  });
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.textPrimary,
                  size: AppSizes.iconSmall,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => produkDihapus = item),
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textPrimary,
                  size: AppSizes.iconSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterPopup(String selectedFilter) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p12,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.cardLargeRadius),
      ),
      child: Column(
        children: [
          _filterItem("makanan", selectedFilter),
          const SizedBox(height: AppSizes.p12),
          _filterItem("minuman", selectedFilter),
          const SizedBox(height: AppSizes.p12),
          _filterItem("Semua", selectedFilter),
        ],
      ),
    );
  }

  Widget _filterItem(String label, String selectedFilter) {
    bool active = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() => showFilterPopup = false);

        ref.read(filterCategoryProvider.notifier).state = label;
        ref.read(productsProvider.notifier).loadProductsByCategory(label);
      },

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p8,
        ),
        decoration: BoxDecoration(
          color: active ? Colors.white : const Color(0xFFEFF8E2),
          borderRadius: BorderRadius.circular(AppSizes.cardSmallRadius),
          border: active ? Border.all(color: AppColors.textPrimary) : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: active
                ? AppColors.textPrimary
                : AppColors.textPrimary.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
