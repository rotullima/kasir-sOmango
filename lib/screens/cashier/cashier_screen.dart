import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/widgets/app_header.dart';
import '/widgets/app_drawer.dart';
import '/widgets/product_card.dart';
import '/constants/app_colors.dart';
import 'package:kasir_s0mango/widgets/cashier_cust.dart';
import 'package:kasir_s0mango/models/cashier_cust.dart';
import 'package:kasir_s0mango/providers/cashier_provider.dart';
import 'package:kasir_s0mango/screens/cashier/cart_summary_screen.dart';

class CashierScreen extends ConsumerStatefulWidget {
  const CashierScreen({super.key});

  @override
  ConsumerState<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends ConsumerState<CashierScreen> {
  CashierCustModel? _selectedCustomer;
  final TextEditingController _searchController = TextEditingController();
  bool isOpen = false;

  void toggleDrawer() {
    setState(() => isOpen = !isOpen);
  }

  Future<void> _openAddCustomer() async {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: CashierCustomDialog(
          type: CashierDialogType.addCustomer,
          nameController: nameCtrl,
          emailController: emailCtrl,
          onCancel: () => Navigator.pop(context),
          onConfirm: () async {
            if (nameCtrl.text.isEmpty) return;

            try {
              final newCustomer = await ref
                  .read(cashierServiceProvider)
                  .addCustomer(name: nameCtrl.text, email: emailCtrl.text);

              ref.invalidate(customersProvider);

              setState(() {
                _selectedCustomer = null;
              });

              if (mounted) Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Gagal tambah pelanggan: $e")),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final customersAsync = ref.watch(customersProvider);
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final List<CashierCustModel> allCustomers = customersAsync.when(
      data: (customers) {
        final list = [
          CashierCustModel(id: null, name: "Walk In", email: "", points: 0),
          ...customers,
        ];

        if (_selectedCustomer != null) {
          final matched = list.firstWhere(
            (c) => c.id == _selectedCustomer!.id,
            orElse: () => list.first,
          );
          _selectedCustomer = matched;
        }

        return list;
      },
      loading: () => [],
      error: (_, __) => [
        CashierCustModel(id: null, name: "Walk In", email: "", points: 0),
      ],
    );

    final CashierCustModel? currentValue = allCustomers.isEmpty
        ? null
        : (_selectedCustomer ?? allCustomers.first);

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
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<CashierCustModel>(
                            value: currentValue,
                            icon: const SizedBox.shrink(),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            dropdownColor: Colors.white,
                            menuMaxHeight: 250,
                            isExpanded: true,
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
                            hint: customersAsync.isLoading
                                ? const Text(
                                    "Loading pelanggan...",
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  )
                                : const Text("Pilih Pelanggan..."),
                            items: allCustomers.map((cust) {
                              return DropdownMenuItem<CashierCustModel>(
                                value: cust,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    cust.id == null
                                        ? cust.name
                                        : "${cust.name} (${cust.email})",
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
                              return allCustomers.map<Widget>((cust) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 1,
                                  ),
                                  child: Text(
                                    cust.name,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList();
                            },

                            onChanged: allCustomers.isEmpty
                                ? null
                                : (val) =>
                                      setState(() => _selectedCustomer = val),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _openAddCustomer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 17,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
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
                      const Text(
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          decoration: InputDecoration(
                            hintText: "search...",
                            hintStyle: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            filled: true,
                            fillColor: AppColors.primary,
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
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
                  child: productsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text("Error: $err")),
                    data: (products) {
                      final query = _searchController.text.toLowerCase();
                      final filtered = products
                          .where((p) => p.name.toLowerCase().contains(query))
                          .toList();

                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text("Produk tidak ditemukan"),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          return GestureDetector(
                            onTap: () => cartNotifier.add(product),
                            child: StockCard(
                              name: product.name,
                              displayValue: product.price,
                              image: product.image,
                              showActions: false,
                            ),
                          );
                        },
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
                      if (cart.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Keranjang masih kosong"),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CartSummaryScreen(customer: _selectedCustomer!),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
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
                  if (cartNotifier.totalItems > 0)
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
                          "${cartNotifier.totalItems}",
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
