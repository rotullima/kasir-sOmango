import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer_screen_model.dart';
import '../services/customer_service.dart';

final customerServiceProvider = Provider<CustomerService>((ref) {
  return CustomerService();
});

final customersProvider =
    StateNotifierProvider<CustomerNotifier, AsyncValue<List<CustomerModel>>>((
      ref,
    ) {
      final service = ref.watch(customerServiceProvider);
      return CustomerNotifier(service);
    });

class CustomerNotifier extends StateNotifier<AsyncValue<List<CustomerModel>>> {
  final CustomerService service;

  CustomerNotifier(this.service) : super(const AsyncLoading()) {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    state = const AsyncLoading();
    try {
      final data = await service.getAllCustomers();
      state = AsyncData(data);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> addCustomer(CustomerModel c) async {
    await service.addCustomer(c);
    await loadCustomers();
  }

  Future<void> updateCustomer(CustomerModel c) async {
    await service.updateCustomer(c);
    await loadCustomers();
  }

  Future<void> deleteCustomer(int id) async {
    await service.deleteCustomer(id);
    await loadCustomers();
  }
}
