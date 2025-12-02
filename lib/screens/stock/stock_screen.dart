import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/update_card.dart';
import '../../../widgets/product_card.dart';
import '/providers/product_provider.dart';
import '/providers/stock_provider.dart';
import '/screens/stock/stock_history_screen.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  bool isOpen = false;

  void toggleDrawer() => setState(() => isOpen = !isOpen);

  Map<String, dynamic>? editing;
  int? stokIdEditing;
  bool isEditing = false;

  TextEditingController? nameCtrl;
  TextEditingController? modalCtrl;

  @override
  void dispose() {
    nameCtrl?.dispose();
    modalCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockAsync = ref.watch(stockListProvider);

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
                    title: "PRODUK > STOK",
                    onToggle: toggleDrawer,
                  ),
                ),

                Expanded(
                  child: stockAsync.when(
                    data: (list) {
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.95,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final item = list[i];

                          print(
                            'Stock item: ${item.nama}, Image: ${item.gambar}',
                          );

                          return StockCard(
                            name: item.nama,
                            displayValue: item.stok,
                            image: item.gambar.isEmpty
                                ? 'https://via.placeholder.com/150'
                                : item.gambar,
                            onEdit: () {
                              setState(() {
                                nameCtrl?.dispose();
                                modalCtrl?.dispose();

                                stokIdEditing = item.stokId;
                                editing = {
                                  "name": item.nama,
                                  "stock": item.stok,
                                  "modal": item.modalPrice,
                                  "gambar": item.gambar,
                                  "produk_id": item.productId,
                                };

                                nameCtrl = TextEditingController(
                                  text: item.nama,
                                );
                                modalCtrl = TextEditingController(
                                  text: item.modalPrice > 0
                                      ? item.modalPrice.toString()
                                      : '',
                                );

                                isEditing = true;
                              });
                            },
                            onDetail: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      StockHistoryScreen(product: item),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text("Error: $e")),
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),

            if (isEditing && editing != null)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    alignment: Alignment.center,
                    child: UpdateCard(
                      isStockEdit: true,
                      productName: editing!["name"],
                      modalPrice: editing!["modal"],
                      currentStock: editing!["stock"],
                      imagePath: editing!["gambar"],
                      pickedImage: null,
                      pickedImageBytes: null,
                      nameController: nameCtrl!,
                      modalPriceController: modalCtrl!,
                      priceController: TextEditingController(),
                      onProductNameChanged: (v) {
                        setState(() {
                          editing!["name"] = v;
                        });
                      },
                      onModalPriceChanged: (v) {
                        final parsed = double.tryParse(v) ?? 0.0;
                        setState(() {
                          editing!["modal"] = parsed;
                        });
                      },

                      onStockChanged: (v) {
                        if (v >= 0) {
                          setState(() {
                            editing!["stock"] = v;
                          });
                        }
                      },
                      onBack: () {
                        setState(() {
                          nameCtrl?.dispose();
                          modalCtrl?.dispose();
                          nameCtrl = null;
                          modalCtrl = null;
                          isEditing = false;
                          editing = null;
                        });
                      },
                      onDone: () async {
                        if (editing?["name"] == null ||
                            editing!["name"].trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Nama produk tidak boleh kosong!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final modalText = modalCtrl?.text ?? '';
                        final parsedModal = double.tryParse(
                          modalText.replaceAll(',', '.'),
                        );
                        if (parsedModal == null || parsedModal <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Modal harus berupa angka lebih dari 0",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final success = await ref
                            .read(updateStockProvider.notifier)
                            .update(
                              stokId: stokIdEditing!,
                              newStock: editing!["stock"],
                              modalPrice: editing!["modal"],
                            );

                        if (success) {
                          final productId = editing?["produk_id"] as String?;
                          if (productId != null && productId.isNotEmpty) {
                            ref
                                .read(productsProvider.notifier)
                                .updateStock(productId, editing!["stock"]);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Stok berhasil diupdate"),
                              backgroundColor: Colors.green,
                            ),
                          );

                          ref.refresh(stockListProvider);

                          setState(() {
                            nameCtrl?.dispose();
                            modalCtrl?.dispose();
                            nameCtrl = null;
                            modalCtrl = null;
                            isEditing = false;
                            editing = null;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Gagal update stok"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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
