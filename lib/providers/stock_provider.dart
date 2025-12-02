import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/stock_service.dart';
import '../models/stock_model.dart';

final stockServiceProvider = Provider((ref) => StockService());

final stockListProvider = FutureProvider<List<StockModel>>((ref) async {
  final service = ref.watch(stockServiceProvider);
  final data = await service.getStocks();

  return data.map((e) {
    print('Raw data: $e');

    final produkData = e["produk"];
    final gambarProduk = produkData is Map
        ? (produkData["gambar_produk"] ?? "")
        : "";
    final namaProduk = produkData is Map
        ? (produkData["nama_produk"] ?? "Unknown")
        : "Unknown";

    print('Gambar URL: $gambarProduk');

    return StockModel(
      stokId: e["stok_id"] ?? 0,
      productId: (e["produk_id"] ?? 0).toString(),
      nama: namaProduk,
      stok: e["stok"] ?? 0,
      gambar: gambarProduk,
      modalPrice: (e["modal_produk"] ?? 0).toDouble(),
    );
  }).toList();
});

final updateStockProvider = StateNotifierProvider<UpdateStockCtrl, bool>((ref) {
  return UpdateStockCtrl(ref);
});

class UpdateStockCtrl extends StateNotifier<bool> {
  UpdateStockCtrl(this.ref) : super(false);
  final Ref ref;

  Future<bool> update({
    required int stokId,
    required int newStock,
    required double modalPrice,
  }) async {
    state = true;

    try {
      await ref
          .read(stockServiceProvider)
          .updateStock(
            stokId: stokId,
            newStock: newStock,
            modalPrice: modalPrice,
          );
      return true;
    } catch (e) {
      print('Error updating stock: $e');
      return false;
    } finally {
      state = false;
    }
  }
}
