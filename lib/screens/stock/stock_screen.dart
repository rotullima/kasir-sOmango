import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/update_card.dart';
import '../../dummy/stock_dummy.dart';
import '../../widgets/product_card.dart';
import '/widgets/app_header.dart';
import '/widgets/app_drawer.dart';
import '/constants/app_colors.dart';
import '/constants/app_sizes.dart';
import '../stock/stock_history_screen.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

Map<String, dynamic>? editingStock;
bool isEditing = false;

class _StockScreenState extends ConsumerState<StockScreen> {
  bool isOpen = false;
  int? editingIndex;
  TextEditingController? _modalPriceController;
  TextEditingController? _nameController;

  void toggleDrawer() {
    setState(() => isOpen = !isOpen);
  }

  @override
  Widget build(BuildContext context) {
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
                    title: 'PRODUK > STOK',
                    onToggle: toggleDrawer,
                  ),
                ),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: dummyProductswithHistory.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.95,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                    itemBuilder: (context, i) {
                      final data = dummyProductswithHistory[i];
                      final item = data.product;

                      return StockCard(
                        name: item.nama,
                        stock: item.stok,
                        image: item.gambar,
                        onEdit: () {
                          setState(() {
                            _modalPriceController?.dispose();
                            _nameController?.dispose();
                            _modalPriceController = TextEditingController(
                              text: item.modalPrice.toStringAsFixed(0),
                            );
                            _nameController = TextEditingController(
                              text: item.nama,
                            );
                            editingIndex = i;
                            editingStock = {
                              "nama": item.nama,
                              "stok": item.stok,
                              "gambar": item.gambar,
                              "modalPrice": item.modalPrice,
                            };
                            isEditing = true;
                          });
                        },
                        onDetail: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StockHistoryScreen(
                                product: item,
                                history: data.history,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),

            if (isEditing && editingStock != null && editingIndex != null)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    alignment: Alignment.center,
                    child: UpdateCard(
                      isStockEdit: true,
                      productName: editingStock!["nama"],
                      currentStock: editingStock!["stok"],
                      modalPrice: editingStock!["modalPrice"],
                      imagePath: editingStock!["gambar"],
                      pickedImage: null,
                      pickedImageBytes: null,
                      nameController: _nameController!,
                      priceController: TextEditingController(),
                      modalPriceController: _modalPriceController,
                      onBack: () {
                        setState(() {
                          _modalPriceController?.dispose();
                          _nameController?.dispose();
                          _modalPriceController = null;
                          _nameController = null;
                          isEditing = false;
                          editingIndex = null;
                        });
                      },
                      onDone: () {
                        if (editingIndex != null) {
                          final updatedProduct =
                              dummyProductswithHistory[editingIndex!].product;
                          updatedProduct.nama = editingStock!["nama"];
                          updatedProduct.stok = editingStock!["stok"];
                          updatedProduct.modalPrice =
                              editingStock!["modalPrice"];
                        }
                        setState(() {
                          _modalPriceController?.dispose();
                          _nameController?.dispose();
                          _modalPriceController = null;
                          _nameController = null;
                          isEditing = false;
                          editingIndex = null;
                        });
                      },
                      onStockChanged: (newStock) {
                        if (newStock >= 0) {
                          setState(() {
                            editingStock!["stok"] = newStock;
                          });
                        }
                      },
                      onProductNameChanged: (newName) {
                        setState(() {
                          editingStock!["nama"] = newName;
                        });
                      },
                      onModalPriceChanged: (newPrice) {
                        setState(() {
                          editingStock!["modalPrice"] =
                              double.tryParse(newPrice) ??
                              editingStock!["modalPrice"];
                        });
                      },
                    ),
                  ),
                ),
              ),

            AppDrawer(isOpen: isOpen, onToggle: toggleDrawer),

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
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
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                      label: const Text(
                        "Kembali",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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
}
