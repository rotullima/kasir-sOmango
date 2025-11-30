class ProductModel {
  final String id;
  String nama;
  int stok; 
  final String gambar;
  double modalPrice; 

  ProductModel({
    required this.id,
    required this.nama,
    required this.stok,
    required this.gambar,
    required this.modalPrice, 
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
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
