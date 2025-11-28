import 'dart:typed_data';
import '/config/supabase_config.dart';

class ProductService {
  final supabase = SupabaseConfig.client;

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final response = await supabase
          .from('produk')
          .select('''
          produk_id,
          nama_produk,
          harga,
          kategori,
          gambar_produk,
          stok (stok)
        ''')
          .order('created_at', ascending: false);

      return (response as List).map((item) {
        final stokList = item['stok'] as List? ?? [];

        return {
          'produk_id': item['produk_id'],
          'nama_produk': item['nama_produk'],
          'harga': item['harga'],
          'kategori': item['kategori'] ?? '',
          'gambar_produk': item['gambar_produk'] ?? '',
          'stok': stokList.isNotEmpty ? stokList[0]['stok'] : 0,
        };
      }).toList();
    } catch (e) {
      throw Exception('Gagal memuat produk: $e');
    }
  }

  Future<void> addProduct({
    required String nama,
    required double harga,
    required String kategori,
    String? gambar,
  }) async {
    try {
      final response = await supabase
          .from('produk')
          .insert({
            'nama_produk': nama,
            'harga': harga,
            'kategori': kategori,
            'gambar_produk': gambar,
          })
          .select('produk_id')
          .single();

      await supabase.from('stok').insert({
        'produk_id': response['produk_id'],
        'stok': 0,
        'modal_produk': 0,
      });
    } catch (e) {
      throw Exception('Gagal menambahkan produk: $e');
    }
  }

  Future<void> updateProduct({
    required int produkId,
    String? nama,
    double? harga,
    String? kategori,
    String? gambar,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (nama != null) updateData['nama_produk'] = nama;
      if (harga != null) updateData['harga'] = harga;
      if (kategori != null) updateData['kategori'] = kategori;
      if (gambar != null) updateData['gambar_produk'] = gambar;

      await supabase
          .from('produk')
          .update(updateData)
          .eq('produk_id', produkId);
    } catch (e) {
      throw Exception('Gagal mengupdate produk: $e');
    }
  }

  Future<void> deleteProduct(int produkId) async {
    try {
      await supabase
          .from('detail_penjualan')
          .delete()
          .eq('produk_id', produkId);

      await supabase.from('riwayat_stok').delete().eq('produk_id', produkId);

      await supabase.from('stok').delete().eq('produk_id', produkId);

      await supabase.from('produk').delete().eq('produk_id', produkId);
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }

  Future<String?> uploadProductImage(Uint8List bytes, String fileName) async {
    try {
      await supabase.storage.from('produk').uploadBinary(fileName, bytes);

      return supabase.storage.from('produk').getPublicUrl(fileName);
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  Future<void> deleteProductImage(String fileName) async {
    try {
      await supabase.storage.from('produk').remove([fileName]);
    } catch (e) {
      throw Exception('Gagal menghapus gambar: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
  try {
    if (category == "Semua") {
      return await getAllProducts();
    }

    final response = await supabase
        .from('produk')
        .select('''
          produk_id,
          nama_produk,
          harga,
          kategori,
          gambar_produk,
          stok (stok)
        ''')
        .eq('kategori', category)
        .order('created_at', ascending: false);

    return (response as List).map((item) {
      final stokList = item['stok'] as List<dynamic>? ?? [];
      final stokValue = stokList.isNotEmpty ? stokList[0]['stok'] as int? ?? 0 : 0;

      return {
        'produk_id': item['produk_id'],
        'nama_produk': item['nama_produk'] ?? '',
        'harga': item['harga'] ?? 0,
        'kategori': item['kategori'] ?? '',
        'gambar_produk': item['gambar_produk'],
        'stok': stokValue,
      };
    }).toList();
  } catch (e) {
    throw Exception('Gagal memuat produk berdasarkan kategori: $e');
  }
}
}
