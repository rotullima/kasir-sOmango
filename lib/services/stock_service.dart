import 'package:supabase_flutter/supabase_flutter.dart';

class StockService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getStocks() async {
    final res = await supabase.from("stok").select("""
          stok_id,
          stok,
          modal_produk,
          produk_id,
          produk:produk_id(
            nama_produk,
            gambar_produk
          )
        """);

    return res;
  }

  Future<void> updateStock({
    required int stokId,
    required int newStock,
    required double modalPrice,
  }) async {
    await supabase
        .from("stok")
        .update({"stok": newStock, "modal_produk": modalPrice})
        .eq("stok_id", stokId);
  }
}
