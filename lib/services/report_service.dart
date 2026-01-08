import '/config/supabase_config.dart';

class ReportService {
  final supabase = SupabaseConfig.client;

  Future<double> getPendapatan({required bool bulanan}) async {
  final now = DateTime.now();

  final startDate = bulanan
      ? DateTime(now.year, now.month, 1)
      : DateTime(now.year, now.month, now.day);

  final res = await supabase
      .from('penjualan')
      .select('total_harga')
      .gte('created_at', startDate.toIso8601String());

  return res.fold<double>(
    0,
    (sum, e) => sum + (e['total_harga'] as num).toDouble(),
  );
}


  Future<double> getModal({required bool bulanan}) async {
    final res = await supabase.rpc(
  'report_modal',
  params: {
    'is_bulanan': bulanan,
  },
);


    return (res ?? 0).toDouble();
  }
}
