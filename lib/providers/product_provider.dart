import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir_s0mango/services/product_service.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

final filterCategoryProvider = StateProvider<String>((ref) => "Semua");

final searchQueryProvider = StateProvider<String>((ref) => "");

final productsProvider =
    StateNotifierProvider<
      ProductsNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) {
      final service = ref.watch(productServiceProvider);
      return ProductsNotifier(ref, service);
    });

class ProductsNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final ProductService _service;
  final Ref _ref;

  ProductsNotifier(this._ref, this._service)
    : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await _service.getAllProducts();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateStock(String productId, int newStock) {
    state = state.whenData((products) {
      return [
        for (final p in products)
          if (p['produk_id'].toString() == productId)
            {...p, 'stok': newStock} 
          else
            Map<String, dynamic>.from(p), 
      ];
    });
  }

  Future<void> loadProductsByCategory(String category) async {
    state = const AsyncValue.loading();
    try {
      final products = category == "Semua"
          ? await _service.getAllProducts()
          : await _service.getProductsByCategory(category);
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProduct({
    required String nama,
    required double harga,
    required String kategori,
    String? gambar,
  }) async {
    await _service.addProduct(
      nama: nama,
      harga: harga,
      kategori: kategori,
      gambar: gambar,
    );
    await loadProductsByCategory(_ref.read(filterCategoryProvider));
  }

  Future<void> updateProduct({
    required int produkId,
    String? nama,
    double? harga,
    String? kategori,
    String? gambar,
  }) async {
    await _service.updateProduct(
      produkId: produkId,
      nama: nama,
      harga: harga,
      kategori: kategori,
      gambar: gambar,
    );
    await loadProductsByCategory(_ref.read(filterCategoryProvider));
  }

  Future<void> deleteProduct(int produkId) async {
    await _service.deleteProduct(produkId);
    await loadProductsByCategory(_ref.read(filterCategoryProvider));
  }
}

final filteredProductsProvider =
    Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
      final productsAsync = ref.watch(productsProvider);
      final search = ref.watch(searchQueryProvider).toLowerCase();

      return productsAsync.whenData((products) {
        return products
            .map(
              (p) => Map<String, dynamic>.from(p),
            ) 
            .where(
              (item) =>
                  item['nama_produk'].toString().toLowerCase().contains(search),
            )
            .toList();
      });
    });
