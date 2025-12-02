class StockDummyModel {
  final String id;
  String nama;
  int stok;
  final String gambar;
  double modalPrice;
  StockDummyModel({
    required this.id,
    required this.nama,
    required this.stok,
    required this.gambar,
    required this.modalPrice,
  });
  factory StockDummyModel.fromMap(Map<String, dynamic> map) {
    return StockDummyModel(
      id: map["id"],
      nama: map["nama"],
      stok: map["stok"],
      gambar: map["gambar"],
      modalPrice: map["modalPrice"]?.toDouble() ?? 0.0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nama": nama,
      "stok": stok,
      "gambar": gambar,
      "modalPrice": modalPrice,
    };
  }
}
