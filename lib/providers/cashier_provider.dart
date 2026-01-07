import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir_s0mango/services/cashier_service.dart';
import 'package:kasir_s0mango/models/cashier_model.dart';
import 'package:kasir_s0mango/models/cashier_cust.dart';

final cashierServiceProvider = Provider((ref) => CashierService());

final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.read(cashierServiceProvider).getProducts();
});

final customersProvider = FutureProvider<List<CashierCustModel>>((ref) async {
  return ref.read(cashierServiceProvider).getCustomers();
});

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<ProductModel, int>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<ProductModel, int>> {
  CartNotifier() : super({});

  void add(ProductModel product) {
    state = {
      ...state,
      product: (state[product] ?? 0) + 1,
    };
  }

  void increment(ProductModel product) {
    state = {
      ...state,
      product: (state[product] ?? 0) + 1,
    };
  }

  void decrement(ProductModel product) {
    if ((state[product] ?? 0) > 1) {
      state = {...state, product: state[product]! - 1};
    }
  }

  void remove(ProductModel product) {
    state = Map.from(state)..remove(product);
  }

  void clear() {
    state = {};
  }

  int get totalItems => state.values.fold(0, (sum, qty) => sum + qty);
}