import 'stock_dummy.dart'; 
import '../models/report_model.dart';

double get totalModal => dummyProductswithHistory.fold(
      0.0,
      (sum, item) => sum + (item.product.stok * item.product.modalPrice),
    );

const double dailyIncome = 463000;
const double monthlyIncome = 12500000;

final List<DailySales> dailySalesReport = [
  DailySales(name: 'jus\nmangga', total: 19),
  DailySales(name: 'mango\nsago', total: 3),
  DailySales(name: 'puding\nmangga', total: 8),
  DailySales(name: 'mango\nsticky', total: 5),
  DailySales(name: 'cake\nmangga', total: 4),
];

final List<RecentTransaction> salesTableData = [
  RecentTransaction(
    no: '1',
    name: 'Jus Mangga',
    date: '19 terjual',
    total: 'Rp190.000,-',
  ),
  RecentTransaction(
    no: '2',
    name: 'Mango Sago',
    date: '3 terjual',
    total: 'Rp36.000,-',
  ),
  RecentTransaction(
    no: '3',
    name: 'Puding Mangga',
    date: '8 terjual',
    total: 'Rp64.000,-',
  ),
  RecentTransaction(
    no: '4',
    name: 'Mango Sticky Rice',
    date: '5 terjual',
    total: 'Rp75.000,-',
  ),
  RecentTransaction(
    no: '5',
    name: 'Cake Mangga',
    date: '4 terjual',
    total: 'Rp80.000,-',
  ),
];

final List<RecentTransaction> productSalesData = [
  RecentTransaction(no: '1', name: 'Jus Mangga', date: '19 terjual', total: 'Rp190.000,-'),
  RecentTransaction(no: '2', name: 'Mango Sago', date: '3 terjual', total: 'Rp36.000,-'),
  RecentTransaction(no: '3', name: 'Puding Mangga', date: '8 terjual', total: 'Rp64.000,-'),
  RecentTransaction(no: '4', name: 'Mango Sticky Rice', date: '5 terjual', total: 'Rp75.000,-'),
  RecentTransaction(no: '5', name: 'Cake Mangga', date: '4 terjual', total: 'Rp80.000,-'),
];

final List<CustomerPurchase> customerPurchases = [
  CustomerPurchase(customerName: 'Cela', itemCount: 12, totalPrice: 190000),
  CustomerPurchase(customerName: 'Asel Evita', itemCount: 3, totalPrice: 36000),
  CustomerPurchase(customerName: 'Egi', itemCount: 5, totalPrice: 64000),
];