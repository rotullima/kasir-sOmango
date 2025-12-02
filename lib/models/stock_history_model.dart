class StockHistoryEntry {
  final String customerName;
  final int quantity;
  final DateTime date;

  StockHistoryEntry({
    required this.customerName,
    required this.quantity,
    required this.date,
  });

  factory StockHistoryEntry.fromMap(Map<String, dynamic> map) {
    final pelangganData = map["pelanggan"];
    final namaCustomer = (pelangganData is Map)
        ? (pelangganData["nama_pelanggan"] ?? "-")
        : "-";

    return StockHistoryEntry(
      customerName: namaCustomer,
      quantity: map["jumlah_perubahan"] ?? 0,
      date: DateTime.parse(
        map["created_at"] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
