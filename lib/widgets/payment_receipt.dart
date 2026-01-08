import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/constants/app_colors.dart';
import 'package:printing/printing.dart';
import '../utils/print_receipt.dart';

void showPaymentSuccessReceipt({
  required BuildContext context,
  required String customerName,
  required String transactionNo,
  required List<Map<String, dynamic>> items,
  required int subtotal,
  required int customerDiscount,
  // required int productDiscount,
  required int totalPayment,
  required String paymentMethod,
  required String cashierName,
  int? cashReceived,
}) {
  final now = DateTime.now();
  final dateStr = DateFormat('yyyy-MM-dd').format(now);
  final timeStr = DateFormat('HH:mm:ss').format(now);

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
                      Text(dateStr, style: _textStyle()),
                      Text(customerName, style: _textStyleBold()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(timeStr, style: _textStyle()),
                      Text("No. $transactionNo", style: _textStyle()),
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
                              "${item['name']}\n${item['qty']} x ${NumberFormat('#,###').format(item['price'])}",
                              style: _textStyle(),
                            ),
                          ),
                          Text(
                            "Rp.${NumberFormat('#,###').format(total)},-",
                            style: _textStyle(),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  _dashedLine(),
                  const SizedBox(height: 16),

                  _priceRow("Subtotal", subtotal),
                  if (customerDiscount > 0)
                    _priceRow("Diskon", customerDiscount),
                  _priceRowBold("Total", totalPayment),

                  const SizedBox(height: 8),
                  _priceRow(
                    "Bayar ${paymentMethod == 'Tunai' ? '' : '(QRIS)'}",
                    cashReceived ?? totalPayment,
                  ),
                  if (paymentMethod == 'Tunai')
                    _priceRow("Kembalian", (cashReceived ?? 0) - totalPayment),

                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Petugas: $cashierName",
                      style: _textStyleBold(size: 13),
                    ),
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
              onPressed: () async {
                final pdf = await generateReceiptPdf(
                  customerName: customerName,
                  transactionNo: transactionNo,
                  items: items,
                  subtotal: subtotal,
                  customerDiscount: customerDiscount,
                  totalPayment: totalPayment,
                  paymentMethod: paymentMethod,
                  cashierName: cashierName,
                  cashReceived: cashReceived,
                );

                await Printing.layoutPdf(
                  onLayout: (format) async => pdf.save(),
                );
                if (context.mounted) {
      Navigator.pop(context); 
      Navigator.pop(context); 
    }
              },

              icon: const Icon(Icons.print),
              label: const Text("Cetak Struk", style: TextStyle(fontSize: 16)),
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
            ),
          ],
        ),
      ),
    ),
  );
}

TextStyle _textStyle() => TextStyle(fontSize: 14, color: AppColors.textPrimary);
TextStyle _textStyleBold({double size = 14}) => TextStyle(
  fontSize: size,
  fontWeight: FontWeight.w600,
  color: AppColors.textPrimary,
);

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
        Text(title, style: _textStyle()),
        Text(
          "Rp.${NumberFormat('#,###').format(value)},-",
          style: _textStyle(),
        ),
      ],
    ),
  );
}

Widget _priceRowBold(String title, int value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: _textStyleBold()),
        Text(
          "Rp.${NumberFormat('#,###').format(value)},-",
          style: _textStyleBold(),
        ),
      ],
    ),
  );
}
