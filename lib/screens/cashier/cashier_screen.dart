import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/widgets/app_header.dart';
import '/widgets/app_drawer.dart';
import '/widgets/product_card.dart';
import '/constants/app_colors.dart';

import 'package:kasir_s0mango/models/cashier_model.dart';
import 'package:kasir_s0mango/models/customer_model.dart';
import 'package:kasir_s0mango/dummy/cashier_dummy.dart';
import 'package:kasir_s0mango/dummy/customer_dummy.dart';
import 'package:kasir_s0mango/screens/cashier/cart_summary_screen.dart';

class CashierScreen extends ConsumerStatefulWidget {
  const CashierScreen({super.key});

  @override
  ConsumerState<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends ConsumerState<CashierScreen> {
  CustomerModel? _selectedCustomer;

  final TextEditingController _searchController = TextEditingController();
  bool isOpen = false;

  void toggleDrawer() {
    setState(() => isOpen = !isOpen);
  }

  List<ProductModel> filteredProducts = dummyProducts;

  Map<ProductModel, int> cartItems = {};
  int get totalItems => cartItems.values.fold(0, (sum, qty) => sum + qty);

  @override
  void initState() {
    super.initState();
    filteredProducts = dummyProducts;

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredProducts = dummyProducts
            .where((p) => p.name.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  void addToCart(ProductModel product) {
    setState(() {
      cartItems[product] = (cartItems[product] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: AppHeader(title: 'KASIR', onToggle: toggleDrawer),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<CustomerModel>(
                            value: _selectedCustomer,
                            icon: const SizedBox.shrink(),

                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),

                            dropdownColor: Colors.white,
                            menuMaxHeight: 250,

                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.primary,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),

                            hint: const Text(
                              "Masukkan Nama Pelanggan...",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),

                            items: dummyCustomers.map((cust) {
                              return DropdownMenuItem(
                                value: cust,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "${cust.name} (${cust.email})",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),

                            selectedItemBuilder: (context) {
                              return dummyCustomers.map((cust) {
                                return Text(
                                  cust.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }).toList();
                            },

                            onChanged: (val) =>
                                setState(() => _selectedCustomer = val),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 17,
                            ),
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_box_outlined, size: 16),
                              SizedBox(width: 6),
                              Text(
                                "Pelanggan Baru",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        "Pilih Produk",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: "search...",
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: AppColors.primary,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 4,
                              ),
                              child: Icon(
                                Icons.search,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 30,
                              minHeight: 0,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () => addToCart(product),
                        child: StockCard(
                          name: product.name,
                          displayValue: product.price,
                          image: product.image,
                          showActions: false,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            AppDrawer(isOpen: isOpen, onToggle: toggleDrawer),

            Positioned(
              right: 20,
              bottom: 20,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (cartItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Keranjang masih kosong"),
                          ),
                        );
                        return;
                      }

                      if (_selectedCustomer == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Pilih pelanggan dulu")),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartSummaryScreen(
                            customer: _selectedCustomer!, 
                            cartItems: Map.from(
                              cartItems,
                            ), 
                          ),
                        ),
                      );
                    },

                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),

                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 40,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  if (totalItems > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$totalItems",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
