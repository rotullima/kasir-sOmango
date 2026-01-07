import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

Future<pw.Document> generateReceiptPdf({
  required String customerName,
  required String transactionNo,
  required List<Map<String, dynamic>> items,
  required int subtotal,
  required int customerDiscount,
  required int productDiscount,
  required int totalPayment,
  required String paymentMethod,
  required String cashierName,
  int? cashReceived,
}) async {
  final pdf = pw.Document();
  final now = DateTime.now();

  final bgColor = PdfColor.fromHex('F9FDF2');
  final textColor = PdfColor.fromHex('81A45F');
  final NumberFormat currency = NumberFormat('#,###');

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      margin: const pw.EdgeInsets.all(8), 
      build: (context) {
        return pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          decoration: pw.BoxDecoration(
            color: bgColor,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(18)),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'sOmango',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),

              pw.SizedBox(height: 24),
              _longDashedLine(),
              pw.SizedBox(height: 20),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    DateFormat('yyyy-MM-dd').format(now),
                    style: pw.TextStyle(fontSize: 12, color: textColor),
                  ),
                  pw.Text(
                    customerName,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    DateFormat('HH:mm:ss').format(now),
                    style: pw.TextStyle(fontSize: 12, color: textColor),
                  ),
                  pw.Text(
                    'No. $transactionNo',
                    style: pw.TextStyle(fontSize: 12, color: textColor),
                  ),
                ],
              ),

              pw.SizedBox(height: 24),
              _longDashedLine(),
              pw.SizedBox(height: 24),

              ...items.map((item) {
                final int qty = item['qty'];
                final int price = item['price'];
                final int total = qty * price;

                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              item['name'],
                              style: pw.TextStyle(fontSize: 13, color: textColor),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              '$qty x ${currency.format(price)}',
                              style: pw.TextStyle(fontSize: 12, color: textColor),
                            ),
                          ],
                        ),
                      ),
                      pw.Text(
                        'Rp.${currency.format(total)},-',
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              pw.SizedBox(height: 24),
              _longDashedLine(),
              pw.SizedBox(height: 20),

              _priceRow('Subtotal', subtotal, textColor),
              if (customerDiscount + productDiscount > 0)
                _priceRow('Diskon', customerDiscount + productDiscount, textColor),

              pw.SizedBox(height: 8),
              _priceRowBold('Total', totalPayment, textColor),

              pw.SizedBox(height: 16),
              _priceRow(
                'Bayar ${paymentMethod == 'Tunai' ? '' : '(QRIS)'}',
                cashReceived ?? totalPayment,
                textColor,
              ),
              if (paymentMethod == 'Tunai' && cashReceived != null)
                _priceRow('Kembalian', cashReceived - totalPayment, textColor),

              pw.SizedBox(height: 32),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Petugas: $cashierName',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  return pdf;
}

pw.Widget _longDashedLine() {
  return pw.Container(
    height: 1.5,
    child: pw.Row(
      children: List.generate(
        15, 
        (_) => pw.Expanded(
          child: pw.Container(
            color: PdfColor.fromHex('81A45F'),
            margin: const pw.EdgeInsets.symmetric(horizontal: 2),
          ),
        ),
      ),
    ),
  );
}

pw.Widget _priceRow(String title, int value, PdfColor textColor) {
  final NumberFormat currency = NumberFormat('#,###');
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 12, color: textColor)),
        pw.Text(
          'Rp.${currency.format(value)},-',
          style: pw.TextStyle(fontSize: 12, color: textColor),
        ),
      ],
    ),
  );
}

pw.Widget _priceRowBold(String title, int value, PdfColor textColor) {
  final NumberFormat currency = NumberFormat('#,###');
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 6),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: textColor),
        ),
        pw.Text(
          'Rp.${currency.format(value)},-',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: textColor),
        ),
      ],
    ),
  );
}