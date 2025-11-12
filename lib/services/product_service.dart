import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../config/supabase_config.dart';

class ProductService {
  final SupabaseClient _client = SupabaseConfig.client;

  // get semua produk
  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await _client.from('produk').select('*').order('created_at');
    return response;
  }

  // add produk baru
  Future<void> addProduct({
    required String nama,
    required double harga,
    required String kategori,
    File? gambar,
  }) async {
    String? imageUrl;

    if (gambar != null) {
      final fileExt = p.extension(gambar.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final filePath = 'produk/$fileName';

      await _client.storage.from('produk_images').upload(filePath, gambar);
      imageUrl = _client.storage.from('produk_images').getPublicUrl(filePath);
    }

    await _client.from('produk').insert({
      'nama_produk': nama,
      'harga': harga,
      'kategori': kategori,
      'gambar_produk': imageUrl,
    });
  }

  // update produk
  Future<void> updateProduct({
    required int id,
    String? nama,
    double? harga,
    String? kategori,
    File? gambar,
  }) async {
    String? imageUrl;

    if (gambar != null) {
      final fileExt = p.extension(gambar.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final filePath = 'produk/$fileName';

      await _client.storage.from('produk_images').upload(filePath, gambar);
      imageUrl = _client.storage.from('produk_images').getPublicUrl(filePath);
    }

    final updateData = <String, dynamic>{};
    if (nama != null) updateData['nama_produk'] = nama;
    if (harga != null) updateData['harga'] = harga;
    if (kategori != null) updateData['kategori'] = kategori;
    if (imageUrl != null) updateData['gambar_produk'] = imageUrl;

    await _client.from('produk').update(updateData).eq('produk_id', id);
  }

  // delete produk
  Future<void> deleteProduct(int id) async {
    await _client.from('produk').delete().eq('produk_id', id);
  }

  Future<File?> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    return picked != null ? File(picked.path) : null;
  }
}