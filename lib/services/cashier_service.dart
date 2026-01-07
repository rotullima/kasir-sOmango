import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir_s0mango/models/cashier_model.dart';
import 'package:kasir_s0mango/models/cashier_cust.dart';

class CashierService {
  final _client = Supabase.instance.client;

  Future<List<ProductModel>> getProducts() async {
    final response = await _client
        .from('produk')
        .select()
        .order('nama_produk', ascending: true);

    return (response as List<dynamic>)
        .map(
          (data) => ProductModel(
            id: data['produk_id'].toString(),
            name: data['nama_produk'] ?? 'produk tanpa nama',
            price: (data['harga'] as num).toInt(),
            image: data['gambar_produk'] ?? 'assets/placeholder_produk.png',
          ),
        )
        .toList();
  }

  Future<List<CashierCustModel>> getCustomers() async {
    final response = await _client
        .from('pelanggan')
        .select()
        .order('nama_pelanggan', ascending: true);

    return (response as List<dynamic>)
        .map(
          (data) => CashierCustModel(
            id: data['pelanggan_id'].toString(),
            name: data['nama_pelanggan'] ?? 'Walk In',
            email: data['email'] ?? '',
            points: (data['poin'] ?? 0).toInt(),
          ),
        )
        .toList();
  }

  Future<CashierCustModel> addCustomer({
    required String name,
    required String email,
  }) async {
    final response = await _client
        .from('pelanggan')
        .insert({'nama_pelanggan': name, 'email': email, 'poin': 0})
        .select()
        .single();

    return CashierCustModel(
      id: response['pelanggan_id'].toString(),
      name: response['nama_pelanggan'],
      email: response['email'],
      points: 0,
    );
  }

  Future<Map<String, String>> saveTransaction({
  required CashierCustModel customer,
  required Map<ProductModel, int> items,
  required int subtotal,
  required int customerDiscount,
  required int productDiscount,
  required int totalPayment,
  required String paymentMethod,
  int? cashReceived,
}) async {
  final userId = _client.auth.currentUser!.id;

  final profile = await _client
      .from('profil')
      .select('nama')
      .eq('user_id', userId)
      .maybeSingle();

  final kasirName = profile?['nama'] ?? 'Kasir';

  final String nomorTransaksi = _generateTransactionNo();

  final penjualanResponse = await _client
      .from('penjualan')
      .insert({
        'total_harga': totalPayment,
        'pelanggan_id': customer.id != null ? int.parse(customer.id!) : null,
        'poin_dipakai': customerDiscount,
        'nomor_transaksi': nomorTransaksi,
        'metode_pembayaran': paymentMethod.toLowerCase(),
        'kasir_id': userId,
      })
      .select()
      .single();

  final int penjualanId = penjualanResponse['penjualan_id'];

    final List<Map<String, dynamic>> details = [];
    for (var entry in items.entries) {
      final product = entry.key;
      final qty = entry.value;

      details.add({
        'penjualan_id': penjualanId,
        'produk_id': int.parse(product.id),
        'jumlah_produk': qty,
        'subtotal': product.price * qty,
        'diskon_produk': productDiscount > 0
            ? (productDiscount / items.length).round()
            : 0,
      });
    }

    if (details.isNotEmpty) {
      await _client.from('detail_penjualan').insert(details);
    }

    if (customer.id != null) {
      final pelangganId = int.parse(customer.id!);

      final currentData = await _client
          .from('pelanggan')
          .select('poin, total_transaksi')
          .eq('pelanggan_id', pelangganId)
          .single();

      final currentPoints = (currentData['poin'] as num?)?.toInt() ?? 0;
      final currentTotalTransaksi =
          (currentData['total_transaksi'] as num?)?.toDouble() ?? 0.0;

      final earnedPoints = (totalPayment / 10000).floor();

      final newPoints = currentPoints - customerDiscount + earnedPoints;

      await _client
          .from('pelanggan')
          .update({
            'poin': newPoints,
            'transaksi_terakhir': totalPayment,
            'total_transaksi': currentTotalTransaksi + totalPayment,
          })
          .eq('pelanggan_id', pelangganId);
    }

    return {
    'nomorTransaksi': nomorTransaksi,
    'kasirName': kasirName,
  };
  }

  String _generateTransactionNo() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    // final year = now.year.toString().substring(2);
    final hour = now.hour.toString().padLeft(2, '0');
    // final minute = now.minute.toString().padLeft(2, '0');
    // final second = now.second.toString().padLeft(2, '0');

    return '$day$month$hour${now.millisecond}';
  }
}
