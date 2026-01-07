 import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  final supabase = Supabase.instance.client;

  Future<List<DailySales>> getDailySales() async {
    final res = await supabase
          .from('detail_penjualan')
          .select('jumlah_produk, produk(nama_produk)')
          .order('jumlah_produk', ascending: false)
          .limit(6);

    return res.map<DailySales>((e) {
      return DailySales(
        name: e['produk']['nama_produk'],
        total: (e['jumlah_produk'] as num).toDouble(),
      );
    }).toList();
  }

  Future<List<MonthlySales>> getMonthlySales() async {
    final res = await supabase.rpc('monthly_sales');

    return res.map<MonthlySales>((e) {
      return MonthlySales(
        month: e['month'],
        total: (e['total'] as num).toDouble(),
      );
    }).toList();
  }

  Future<List<RecentTransaction>> getRecentTransactions() async {
    final res = await supabase
        .from('penjualan')
        .select('nomor_transaksi, total_harga, created_at, pelanggan(nama_pelanggan)')
        .order('created_at', ascending: false)
        .limit(5);
    
    return List.generate(res.length, (i) {
      final e = res[i];
      return RecentTransaction(no: '${i + 1}', name: e['pelanggan']['nama_pelanggan'] ?? '-', date: DateFormat('dd MMM yyyy').format(DateTime.parse(e['created_at']),), total: 'Rp${e['total_harga']}');
    });
  }

  Future<List<ProductStock>>  getProductStock() async {
    final res = await supabase
        .from('stok')
        .select('stok, produk(nama_produk)');

    return res.map<ProductStock>((e) {
      return ProductStock(name: e['produk']['nama_produk'], stock: e['stok'],);
    }).toList();
  }

  Future<int> fetchActiveCustomersLastMonth() async {
  final res = await supabase.rpc(
    'count_active_customers_last_month',
  );

  return res as int;
}

}