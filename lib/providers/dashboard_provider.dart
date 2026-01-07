import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/dashboard_service.dart';
import '../models/dashboard_model.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>(
  (ref) => DashboardNotifier(),
);

class DashboardState {
  final bool loading;
  final List<DailySales> dailySales;
  final List<MonthlySales> monthlySales;
  final List<RecentTransaction> transactions;
  final List<ProductStock> productStocks;
  final int activeCustomers;

  const DashboardState({
    this.loading = true,
    this.dailySales = const [],
    this.monthlySales = const [],
    this.transactions = const [],
    this.productStocks = const [],
    this.activeCustomers = 0,
  });
}


class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(const DashboardState());

  final service = DashboardService();

  Future<void> loadDashboard() async {
    state = const DashboardState(loading: true);

    final daily = await service.getDailySales();
    final monthly = await service.getMonthlySales();
    final trx = await service.getRecentTransactions();
    final stocks = await service.getProductStock();
    final activeCustomers = await service.fetchActiveCustomersLastMonth();

    state = DashboardState(
      loading: false,
      dailySales: daily,
      monthlySales: monthly,
      transactions: trx,
      productStocks: stocks,
      activeCustomers: activeCustomers
    );
  }
}

