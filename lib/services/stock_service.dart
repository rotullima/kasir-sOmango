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

  Future<void> reduceStockAfterSale({
  required int produkId,
  required int qty,
  int? pelangganId,
}) async {
  // 1️⃣ Ambil stok berdasarkan produk
  final stockData = await supabase
      .from("stok")
      .select("stok_id, stok")
      .eq("produk_id", produkId)
      .single();

  final int stokId = stockData["stok_id"];
  final int currentStock = stockData["stok"];

  // 2️⃣ Validasi
  if (currentStock < qty) {
    throw Exception("Stok tidak mencukupi");
  }

  // 3️⃣ Hitung stok baru
  final int newStock = currentStock - qty;

  // 4️⃣ Update stok
  await supabase
      .from("stok")
      .update({"stok": newStock})
      .eq("stok_id", stokId);

  // 5️⃣ Insert ke riwayat_stok
  await supabase.from("riwayat_stok").insert({
    "stok_id": stokId,
    "produk_id": produkId,
    "pelanggan_id": pelangganId,
    "jumlah_perubahan": -qty, // 🔥 keluar = negatif
    "created_at": DateTime.now().toIso8601String(),
  });
}

}
