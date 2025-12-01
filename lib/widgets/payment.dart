import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/constants/app_colors.dart';
import '../screens/cashier/cashier_screen.dart';

void showPaymentSuccessReceipt({
  required BuildContext context,
  required String customerName,
  required List<Map<String, dynamic>> items, 
  required int subtotal,
  required String transactionNo,
  required int customerDiscount,
  required int productDiscount,
  required int totalPayment,
  required String paymentMethod, 
  int? cashReceived,
  required String cashierName,
}) {
  final now = DateTime.now();
  final dateStr = DateFormat('yyyy-MM-dd').format(now);
  final timeStr = DateFormat('HH:mm:ss').format(now);

  int hour = now.hour;
  String shiftCode = hour >= 1 && hour <= 12 ? "1" : "2";
  String transactionNo = "$shiftCode-${now.millisecondsSinceEpoch % 5000}";

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5FFE8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    "sOmango",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),
                  _dashedLine(),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        customerName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        "No. $transactionNo",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  _dashedLine(),
                  const SizedBox(height: 16),

                  ...items.map((item) {
                    final total = item['qty'] * item['price'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              "${item['name']} \n${item['qty']} x ${NumberFormat('#,###').format(item['price'])}",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            "Rp.${NumberFormat('#,###').format(total)},-",
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  _dashedLine(),
                  const SizedBox(height: 16),

                  _priceRow("Diskon", customerDiscount + productDiscount),
                  _priceRow("Total", subtotal),

                  const SizedBox(height: 6),
                  _priceRow("Bayar", cashReceived ?? totalPayment),
                  _priceRow(
                    "Kembalian",
                    (cashReceived ?? totalPayment) - totalPayment,
                  ),

                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Petugas: $cashierName",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "PEMBAYARAN BERHASIL",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CashierScreen(),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textSecondary,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.receipt_long),
              label: Text(
                "Cetak Struk",
                style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _dashedLine() {
  return Row(
    children: List.generate(
      32,
      (_) => Expanded(
        child: Container(
          height: 1.2,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          color: Colors.black45,
        ),
      ),
    ),
  );
}

Widget _priceRow(String title, int value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          "Rp.${NumberFormat('#,###').format(value)},-",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    ),
  );
}
