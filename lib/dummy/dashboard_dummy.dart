import '../models/dashboard_model.dart';

final dailySalesDummy = [
  DailySales(name: 'jus\nmangga', total: 15),
  DailySales(name: 'mango\nsago', total: 12),
  DailySales(name: 'puding\nmangga', total: 10),
  DailySales(name: 'mango\nsticky', total: 18),
  DailySales(name: 'cake\nmangga', total: 8),
  DailySales(name: 'asinan\nmangga', total: 6),
];

final monthlySalesDummy = [
  MonthlySales(month: 'Jan', total: 100),
  MonthlySales(month: 'Feb', total: 170),
  MonthlySales(month: 'Mar', total: 200),
  MonthlySales(month: 'Apr', total: 290),
  MonthlySales(month: 'Mei', total: 300),
  MonthlySales(month: 'Jun', total: 220),
];

final recentTransactionsDummy = [
  RecentTransaction(
    no: '1',
    name: 'Cela',
    date: '14 Okt 2025',
    total: 'Rp24.000,-',
  ),
  RecentTransaction(
    no: '2',
    name: 'Tasya',
    date: '14 Okt 2025',
    total: 'Rp37.000,-',
  ),
];

final productStockDummy = [
  ProductStock(name: 'jus mangga', stock: 20),
  ProductStock(name: 'mango sago', stock: 15),
  ProductStock(name: 'puding mangga', stock: 12),
  ProductStock(name: 'mango sticky rice', stock: 25),
  ProductStock(name: 'cake mangga', stock: 5),
  ProductStock(name: 'asinan mangga', stock: 10),
];
