class StockModel {
  final int stokId;
  final String productId;
  String nama;
  int stok;
  String gambar;
  double modalPrice;

  StockModel({
    required this.stokId,
    required this.productId,
    required this.nama,
    required this.stok,
    required this.gambar,
    required this.modalPrice,
  });

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      stokId: map["stok_id"],
      productId: map["produk_id"].toString(),
      nama: map["nama_produk"] ?? "",
      stok: map["stok"] ?? 0,
      gambar: map["gambar_produk"] ?? "",
      modalPrice: (map["modal_produk"] as num?)?.toDouble() ?? 0.0,
    );
  }
}
