import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/widgets/app_header.dart';
import '/widgets/app_drawer.dart';
import '../../widgets/payment_receipt.dart';
import '/constants/app_colors.dart';

import 'package:kasir_s0mango/providers/cashier_provider.dart';

import 'package:kasir_s0mango/models/cashier_model.dart';
import 'package:kasir_s0mango/models/cashier_cust.dart';

class CartSummaryScreen extends ConsumerStatefulWidget {
  final CashierCustModel customer;

  const CartSummaryScreen({
    super.key,
    required this.customer,
  });

  @override
  ConsumerState<CartSummaryScreen> createState() => _CartSummaryScreenState();
}

class _CartSummaryScreenState extends ConsumerState<CartSummaryScreen> {
  bool isOpen = false;

  void toggleDrawer() => setState(() => isOpen = !isOpen);

  late Map<ProductModel, int> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = Map.from(ref.read(cartProvider));
  }

  int get subtotal {
    int total = 0;
    cartItems.forEach((product, qty) => total += product.price * qty);
    return total;
  }

  int get customerDiscount {
    return (widget.customer.points / 1000).floor() * 1000;
  }

  int get productDiscount {
    return 1700; 
  }

  int get totalPayment {
    return subtotal - customerDiscount - productDiscount;
  }

  void increment(ProductModel p) {
    setState(() {
      cartItems[p] = (cartItems[p] ?? 0) + 1;
    });
    ref.read(cartProvider.notifier).increment(p);
  }

  void decrement(ProductModel p) {
    setState(() {
      if ((cartItems[p] ?? 0) > 1) {
        cartItems[p] = cartItems[p]! - 1;
      }
    });
    ref.read(cartProvider.notifier).decrement(p);
  }

  void remove(ProductModel p) {
    setState(() => cartItems.remove(p));
    ref.read(cartProvider.notifier).remove(p);
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  Future<void> _processPayment({
    required String method,
    int? cashReceived,
  }) async {
    final service = ref.read(cashierServiceProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    try {
      final result = await service.saveTransaction(
  customer: widget.customer,
  items: cartItems,
  subtotal: subtotal,
  customerDiscount: customerDiscount,
  productDiscount: productDiscount,
  totalPayment: totalPayment,
  paymentMethod: method,
  cashReceived: cashReceived,
  // cashierName: cashierName,
);

final nomorTransaksi = result['nomorTransaksi']!;
final cashierName = result['kasirName']!;


      cartNotifier.clear();

      ref.invalidate(customersProvider);

      if (mounted) {
        showPaymentSuccessReceipt(
          context: context,
          customerName: widget.customer.name,
          transactionNo: nomorTransaksi,
          items: cartItems.entries
              .map((e) => {
                    "name": e.key.name,
                    "qty": e.value,
                    "price": e.key.price,
                  })
              .toList(),
          subtotal: subtotal,
          customerDiscount: customerDiscount,
          productDiscount: productDiscount,
          totalPayment: totalPayment,
          paymentMethod: method == "qris" ? "QRIS" : "Tunai",
          cashReceived: cashReceived,
          cashierName: cashierName,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal simpan transaksi: $e")),
        );
      }
    }
  }

  void handleQrisPayment() {
    _processPayment(method: "qris");
  }

  void handleCashPayment() {
    final TextEditingController amountController = TextEditingController();
    int amountPaid = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.all(32),
          titlePadding: const EdgeInsets.only(top: 32),
          contentPadding: const EdgeInsets.symmetric(horizontal: 32),
          actionsPadding: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
          title: const Text(
            "Rincian Pembayaran Tunai",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text("Uang Tunai", style: TextStyle(fontSize: 16, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: true,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.background,
                  prefixText: "Rp. ",
                  suffixText: ",-",
                  hintText: "0",
                  hintStyle: const TextStyle(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
                onChanged: (value) {
                  final clean = value.replaceAll(RegExp(r'[^\d]'), '');
                  setStateDialog(() => amountPaid = int.tryParse(clean) ?? 0);
                },
              ),
              const SizedBox(height: 18),
              const Text("Kembalian", style: TextStyle(fontSize: 16, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
                child: Text(
                  amountPaid >= totalPayment
                      ? "Rp.${_formatNumber(amountPaid - totalPayment)},-"
                      : "Rp.${_formatNumber(totalPayment - amountPaid)},- (kurang)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: amountPaid >= totalPayment ? AppColors.textPrimary : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton.icon(
                onPressed: amountPaid >= totalPayment
                    ? () {
                        Navigator.pop(dialogContext);
                        _processPayment(method: "tunai", cashReceived: amountPaid);
                      }
                    : null,
                icon: const Icon(Icons.check_box_outlined, size: 22),
                label: const Text("Selesai", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textSecondary,
                  foregroundColor: AppColors.textPrimary,
                  disabledBackgroundColor: Colors.grey[400],
                  disabledForegroundColor: Colors.grey[600],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: AppHeader(
                    title: "KASIR > RINGKASAN",
                    onToggle: toggleDrawer,
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Ringkasan Pesanan:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                widget.customer.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Column(
                          children: cartItems.entries.map((entry) {
                            final product = entry.key;
                            final qty = entry.value;

                            return Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: product.image.isEmpty
      ? Container(
          width: 55,
          height: 55,
          color: Colors.grey[300],
          child: const Icon(Icons.fastfood, color: Colors.white, size: 30),
        )
      : Image.network(
          product.image,
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 55,
              height: 55,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 55,
              height: 55,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            );
          },
        ),
),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 8),

                                        Row(
                                          children: [
                                            Text(
                                              "Rp.${product.price},-",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            const Spacer(),

                                            GestureDetector(
                                              onTap: () => decrement(product),
                                              child: const Icon(
                                                Icons.remove_circle_outline,
                                                size: 20,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "$qty",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () => increment(product),
                                              child: const Icon(
                                                Icons.add_circle_outline,
                                                size: 20,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),

                                            const SizedBox(width: 12),

                                            Text(
                                              "Rp.${product.price * qty},-",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColors.primary,
                                              ),
                                            ),

                                            const SizedBox(width: 12),

                                            GestureDetector(
                                              onTap: () => remove(product),
                                              child: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                                size: 22,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Rincian Pembayaran",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _row("Subtotal Pesanan:", "Rp.$subtotal"),
                              _row(
                                "Diskon Pelanggan:",
                                "- Rp.$customerDiscount",
                              ),
                              _row("Diskon Produk:", "- Rp.$productDiscount"),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(
                                  thickness: 1,
                                  color: AppColors.primary,
                                ),
                              ),
                              _rowBold("Total Pembayaran:", "Rp.$totalPayment"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          "Metode Pembayaran",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 14),

                        GestureDetector(
                          onTap: handleQrisPayment,
                          child: _payButton("assets/qris.png", "QRIS"),
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: handleCashPayment,
                          child: _payButton("assets/cash.png", "Tunai"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            AppDrawer(isOpen: isOpen, onToggle: toggleDrawer),
          ],
        ),
      ),
    );
  }

  Widget _row(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          Text(
            right,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _rowBold(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          right,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _payButton(String iconPath, String text) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Image.asset(iconPath, width: 50, height: 50),
          const Spacer(),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 18),
        ],
      ),
    );
  }
}
