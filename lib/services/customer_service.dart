import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/customer_screen_model.dart';

class CustomerService {
  final supabase = Supabase.instance.client;

  Future<List<CustomerModel>> getAllCustomers() async {
    final res = await supabase.from('pelanggan').select().order('pelanggan_id');
    return res.map((e) => CustomerModel.fromJson(e)).toList();
  }

  Future<CustomerModel> addCustomer(CustomerModel c) async {
    final res = await supabase
        .from('pelanggan')
        .insert(c.toJson())
        .select()
        .single();
    return CustomerModel.fromJson(res);
  }

  Future<void> updateCustomer(CustomerModel c) async {
    if (c.id == null) return;
    await supabase
        .from('pelanggan')
        .update(c.toJson())
        .eq('pelanggan_id', c.id!);
  }

  Future<void> deleteCustomer(int id) async {
    final supa = supabase;

    await supa.from('penjualan').delete().eq('pelanggan_id', id);

    await supa.from('riwayat_stok').delete().eq('pelanggan_id', id);

    await supa.from('pelanggan').delete().eq('pelanggan_id', id);
  }
}
