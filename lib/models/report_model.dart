class SaleItem {
  final String productName;
  final int quantity;
  final double totalPrice;

  SaleItem({required this.productName, required this.quantity, required this.totalPrice});
}

class DailySales {
  final String name;
  final int total;
  DailySales({required this.name, required this.total});
}

class RecentTransaction {
  final String no;
  final String name;
  final String date;
  final String total;
  RecentTransaction({required this.no, required this.name, required this.date, required this.total});
}

class CustomerPurchase {
  final String customerName;
  final int itemCount;
  final int totalPrice;

  CustomerPurchase({
    required this.customerName,
    required this.itemCount,
    required this.totalPrice,
  });
}