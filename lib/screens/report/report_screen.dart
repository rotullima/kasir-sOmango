import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/constants/app_colors.dart';
import '/constants/app_sizes.dart';
import '/constants/app_textStyles.dart';
import '/widgets/app_header.dart';
import '/widgets/app_drawer.dart';
import '../../dummy/report_dummy.dart';
import '/widgets/section_card.dart';
import '/widgets/bar_chart.dart';
import '/widgets/table.dart';

final reportPeriodProvider = StateProvider<String>((ref) => 'Harian');

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  bool isOpen = false;
  bool showFilterPopup = false;
  String selectedFilter = 'Produk'; 

  void toggleDrawer() => setState(() => isOpen = !isOpen);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final period = ref.watch(reportPeriodProvider);
    final pendapatan = period == 'Harian' ? dailyIncome : monthlyIncome;
    final labaRugi = pendapatan - totalModal;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p16),
                  child: AppHeader(title: 'LAPORAN', onToggle: toggleDrawer),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              ref.read(reportPeriodProvider.notifier).state =
                                  'Harian',
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: period == 'Harian'
                                  ? Colors.transparent
                                  : AppColors.primary, 
                              border: period == 'Harian'
                                  ? Border.all(
                                      color: AppColors.textPrimary,
                                      width: 2,
                                    ) 
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Harian',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: period == 'Harian'
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              ref.read(reportPeriodProvider.notifier).state =
                                  'Bulanan',
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: period == 'Bulanan'
                                  ? Colors.transparent
                                  : AppColors.primary,
                              border: period == 'Bulanan'
                                  ? Border.all(
                                      color: AppColors.textPrimary,
                                      width: 2,
                                    ) 
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Bulanan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: period == 'Bulanan'
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => setState(() => showFilterPopup = !showFilterPopup),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.filter_alt_outlined, color: AppColors.textPrimary, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.sectionGap),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  child: Row(
                    children: [
                      Expanded(child: _summaryCard("Modal", totalModal, AppColors.textSecondary)),
                      const SizedBox(width: 12),
                      Expanded(child: _summaryCard("Pendapatan", pendapatan, AppColors.textSecondary)),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        const Text('RP Laba Rugi', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(formatRupiah(labaRugi),
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                            color: labaRugi >= 0 ? Colors.green[800] : Colors.red[800]),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.sectionGap),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                    child: Column(
                      children: [
                        if (selectedFilter == 'Produk')
                        SectionCard(
                          title: 'Penjualan Hari Ini',
                          trailing: Text('Rp. ${formatRupiah(pendapatan)},00',
                            style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold).copyWith(color: AppColors.textSecondary)),
                          child: AppBarChart(data: dailySalesReport),
                        ),


                        const SizedBox(height: AppSizes.sectionGap),

                        if (selectedFilter == 'Produk')
                          SectionCard(
                            title: 'Laporan Penjualan Produk',
                            child: TransactionTable(data: productSalesData),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Laporan Pembelian Pelanggan',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                                const SizedBox(height: 16),
                                Row(
                                  children: const [
                                    Expanded(flex: 2, child: Text('Pelanggan', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
                                    Expanded(child: Text('Jumlah Produk', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary), textAlign: TextAlign.center,)),
                                    Expanded(flex: 2, child: Text('Total Harga', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary), textAlign: TextAlign.right)),
                                  ],
                                ),
                                const Divider(height: 24, color: Colors.white70),
                                ...customerPurchases.map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 2, child: Text(e.customerName, style: TextStyle(color: AppColors.textSecondary,) )),
                                      Expanded(child: Text(e.itemCount.toString(), style: TextStyle(color: AppColors.textSecondary,), textAlign: TextAlign.center)),
                                      Expanded(flex: 2, child: Text(formatRupiah(e.totalPrice.toDouble()), style: TextStyle(color: AppColors.textSecondary,),  textAlign: TextAlign.right)),
                                    ],
                                  ),
                                )),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              left: 80,
              right: 80,
              bottom: 20,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print),
                label: const Text('Cetak Laporan Penjualan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textSecondary,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),

            if (showFilterPopup)
              Positioned(
                top: 140,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        _filterItem('Produk', () {
                          setState(() {
                            selectedFilter = 'Produk';
                            showFilterPopup = false;
                          });
                        }, selectedFilter),
                        const SizedBox(height: 12),
                        _filterItem('Pelanggan', () {
                          setState(() {
                            selectedFilter = 'Pelanggan';
                            showFilterPopup = false;
                          });
                        }, selectedFilter),
                      ],
                    ),
                  ),
                ),
              ),

            AppDrawer(isOpen: isOpen, onToggle: toggleDrawer),
          ],
        ),
      ),
    );
  }

  Widget _filterItem(String label, VoidCallback onTap, String selected) {
    bool active = selected == label;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.background : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: active ? Border.all(color: AppColors.textPrimary) : null,
        ),
        child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: active ? AppColors.textPrimary : AppColors.textPrimary.withOpacity(0.8))),
      ),
    );
  }

  Widget _summaryCard(String label, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RP $label',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold).copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            formatRupiah(amount),
            style: AppTextStyles.title.copyWith(fontWeight: FontWeight.bold).copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
String formatRupiah(double amount) {
  final str = amount.toInt().toString();
  return str.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );
}
