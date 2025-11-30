import '../models/stock_model.dart';
import '../models/stock_history_model.dart';

class ProductwithHistory {
  final ProductModel product;
  final List<StockHistoryEntry> history;

  ProductwithHistory({required this.product, required this.history});
}

final List<ProductwithHistory> dummyProductswithHistory = [
  ProductwithHistory(
    product: ProductModel(
      id: "1",
      nama: "Asinan Mangga",
      stok: 6,
      gambar: "assets/asinan.png",
      modalPrice: 5000,
    ),
    history: [
      StockHistoryEntry(
        customerName: "Siti",
        quantity: 2,
        date: DateTime(2025, 10, 15),
      ),
      StockHistoryEntry(
        customerName: "Rudi",
        quantity: 4,
        date: DateTime(2025, 10, 14),
      ),
    ],
  ),
  ProductwithHistory(
    product: ProductModel(
      id: "2",
      nama: "Mango Sticky Rice",
      stok: 9,
      gambar: "assets/stickyrice.png",
      modalPrice: 12000,
    ),
    history: [
      StockHistoryEntry(
        customerName: "Egi",
        quantity: 2,
        date: DateTime(2025, 10, 15),
      ),
      StockHistoryEntry(
        customerName: "Cela",
        quantity: 4,
        date: DateTime(2025, 10, 14),
      ),
    ],
  ),
  ProductwithHistory(
    product: ProductModel(
      id: "3",
      nama: "Puding Mangga",
      stok: 18,
      gambar: "assets/puding.png",
      modalPrice: 8000,
    ),
    history: [
      StockHistoryEntry(
        customerName: "Siti",
        quantity: 2,
        date: DateTime(2025, 10, 15),
      ),
      StockHistoryEntry(
        customerName: "Rudi",
        quantity: 4,
        date: DateTime(2025, 10, 14),
      ),
    ],
  ),
  ProductwithHistory(
    product: ProductModel(
      id: "4",
      nama: "Cake Mangga",
      stok: 4,
      gambar: "assets/cake.png",
      modalPrice: 25000, 
    ),
    history: [
      StockHistoryEntry(
        customerName: "Siti",
        quantity: 2,
        date: DateTime(2025, 10, 15),
      ),
      StockHistoryEntry(
        customerName: "Rudi",
        quantity: 4,
        date: DateTime(2025, 10, 14),
      ),
    ],
  ),
  ProductwithHistory(
    product: ProductModel(
      id: "5",
      nama: "Mango Sago",
      stok: 10,
      gambar: "assets/sago.png",
      modalPrice: 15000, 
    ),
    history: [
      StockHistoryEntry(customerName: "Siti", quantity: 2, date: DateTime(2025, 10, 15),),
      StockHistoryEntry(customerName: "Rudi", quantity: 4, date: DateTime(2025, 10, 14),),
    ],
  ),
  ProductwithHistory(
    product: ProductModel(
      id: "6",
      nama: "Jus Mangga",
      stok: 17,
      gambar: "assets/jus.png",
      modalPrice: 10000, 
    ),
    history: [
      StockHistoryEntry(customerName: "Siti", quantity: 2, date: DateTime(2025, 10, 15),),
      StockHistoryEntry(customerName: "Rudi", quantity: 4, date: DateTime(2025, 10, 14),),
    ],
  ),
];
