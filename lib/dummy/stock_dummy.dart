import '../models/stock_dummy_model.dart';
import '../models/stock_history_dummy_model.dart';

class ProductwithHistory {
  final StockDummyModel product;
  final List<StockHistoryDummyEntry> history;

  ProductwithHistory({required this.product, required this.history});
}

final List<ProductwithHistory> dummyProductswithHistory = [
  ProductwithHistory(
    product: StockDummyModel(
      id: "1",
      nama: "Asinan Mangga",
      stok: 6,
      gambar: "assets/asinan.png",
      modalPrice: 5000,
    ),
    history: [
      StockHistoryDummyEntry(
        customerName: "Siti",
        quantity: 2,
        date: DateTime(2025, 10, 15),
      ),
      StockHistoryDummyEntry(
        customerName: "Rudi",
        quantity: 4,
        date: DateTime(2025, 10, 14),
      ),
    ],
  ),
  ProductwithHistory(
    product: StockDummyModel(
      id: "2",
      nama: "Mango Sticky Rice",
      stok: 9,
      gambar: "assets/stickyrice.png",
      modalPrice: 12000,
    ),
    history: [
      StockHistoryDummyEntry(
        customerName: "Egi",
        quantity: 2,
        date: DateTime(2025, 10, 15),
      ),
      StockHistoryDummyEntry(
        customerName: "Cela",
        quantity: 4,
        date: DateTime(2025, 10, 14),
      ),
    ],
  ),
  ProductwithHistory(
    product: StockDummyModel(
      id: "3",
      nama: "Puding Mangga",
      stok: 18,
      gambar: "assets/puding.png",
      modalPrice: 8000,
    ),
    history: [
      StockHistoryDummyEntry(
        customerName: "Siti",
        quantity: 2,
        date: DateTime(2025, 10, 15),
      ),
      StockHistoryDummyEntry(
        customerName: "Rudi",
        quantity: 4,
        date: DateTime(2025, 10, 14),
      ),
    ],
  ),
  ProductwithHistory(
    product: StockDummyModel(
      id: "4",
      nama: "Cake Mangga",
      stok: 4,
      gambar: "assets/cake.png",
      modalPrice: 25000,
    ),
    history: [
      StockHistoryDummyEntry(
        customerName: "Siti",
        quantity: 2,
        date: DateTime(2025, 10, 15),
      ),
      StockHistoryDummyEntry(
        customerName: "Rudi",
        quantity: 4,
        date: DateTime(2025, 10, 14),
      ),
    ],
  ),
  ProductwithHistory(
    product: StockDummyModel(
      id: "5",
      nama: "Mango Sago",
      stok: 10,
      gambar: "assets/sago.png",
      modalPrice: 15000,
    ),
    history: [
      StockHistoryDummyEntry(
        customerName: "Siti",
        quantity: 2,
        date: DateTime(2025, 10, 15),
      ),
      StockHistoryDummyEntry(
        customerName: "Rudi",
        quantity: 4,
        date: DateTime(2025, 10, 14),
      ),
    ],
  ),
  ProductwithHistory(
    product: StockDummyModel(
      id: "6",
      nama: "Jus Mangga",
      stok: 17,
      gambar: "assets/jus.png",
      modalPrice: 10000,
    ),
    history: [
      StockHistoryDummyEntry(
        customerName: "Siti",
        quantity: 2,
        date: DateTime(2025, 10, 15),
      ),
      StockHistoryDummyEntry(
        customerName: "Rudi",
        quantity: 4,
        date: DateTime(2025, 10, 14),
      ),
    ],
  ),
];
