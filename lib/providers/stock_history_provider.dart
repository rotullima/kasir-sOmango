import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/stock_history_service.dart';
import '../models/stock_history_model.dart';

final stockHistoryServiceProvider = Provider((ref) => StockHistoryService());

final stockHistoryProvider =
    FutureProvider.family<List<StockHistoryEntry>, int>((ref, productId) async {
  final service = ref.read(stockHistoryServiceProvider);
  return service.getStockHistory(productId);
});
