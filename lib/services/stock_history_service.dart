import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/stock_history_model.dart';

class StockHistoryService {
  final supabase = Supabase.instance.client;

  Future<List<StockHistoryEntry>> getStockHistory(int productId) async {
    try {
      final data = await supabase
          .from("riwayat_stok")
          .select("""
          jumlah_perubahan,
          created_at,
          pelanggan:pelanggan_id(
            nama_pelanggan
          )
        """)
          .eq("produk_id", productId)
          .order("created_at", ascending: false)
          .then((value) => List<Map<String, dynamic>>.from(value));

      return data.map((e) => StockHistoryEntry.fromMap(e)).toList();
    } catch (e) {
      throw Exception("Failed to fetch stock history: $e");
    }
  }
}
