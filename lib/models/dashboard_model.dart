class DailySales {
  final String name;
  final double total;

  DailySales({required this.name, required this.total});
}

class MonthlySales {
  final String month;
  final double total;

  MonthlySales({required this.month, required this.total});
}

class RecentTransaction {
  final String no;
  final String name;
  final String date;
  final String total;

  RecentTransaction({
    required this.no,
    required this.name,
    required this.date,
    required this.total,
  });
}

class ProductStock {
  final String name;
  final int stock;

  ProductStock({required this.name, required this.stock});
}
