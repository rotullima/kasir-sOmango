class CustomerModel {
  final int? id;
  String name;
  String email;
  int points;
  int lastTransaction;
  int totalSpent;

  CustomerModel({
    this.id,
    required this.name,
    required this.email,
    this.points = 0,
    this.lastTransaction = 0,
    this.totalSpent = 0,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['pelanggan_id'],
      name: json['nama_pelanggan'] ?? '',
      email: json['email'] ?? '',
      points: (json['poin'] ?? 0).toInt(),
      lastTransaction: (json['transaksi_terakhir'] ?? 0).toInt(),
      totalSpent: (json['total_transaksi'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_pelanggan': name,
      'email': email,
      'poin': points,
      'transaksi_terakhir': lastTransaction,
      'total_transaksi': totalSpent,
    };
  }
}
