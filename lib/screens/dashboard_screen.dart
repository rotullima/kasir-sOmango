import 'package:flutter/material.dart';
import '../dummy/dashboard_dummy.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_textStyles.dart';
import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bar_chart.dart';
import '../widgets/line_chart.dart';
import '../widgets/section_card.dart';
import '../widgets/table.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isOpen = false;

  void toggleDrawer() {
    setState(() => isOpen = !isOpen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.p16,
                    left: AppSizes.p16,
                    right: AppSizes.p16,
                  ),
                  child: AppHeader(title: 'DASHBOARD', onToggle: toggleDrawer),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                      vertical: AppSizes.p16,
                    ).copyWith(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(height: AppSizes.sectionGap),

                        SectionCard(
                          title: 'Penjualan Harian',
                          child: AppBarChart(data: dailySalesDummy),
                        ),

                        const SizedBox(height: AppSizes.sectionGap),

                        SectionCard(
                          title: 'Penjualan Bulanan',
                          child: AppLineChart(data: monthlySalesDummy),
                        ),

                        const SizedBox(height: AppSizes.sectionGap),

                        SectionCard(
                          title: 'Daftar Transaksi Terbaru',
                          child: TransactionTable(
                            data: recentTransactionsDummy,
                          ),
                        ),

                        const SizedBox(height: AppSizes.sectionGap),

                        Card(
                          color: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.cardLargeRadius,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 16,
                            ),
                            child: Center(
                              child: Text(
                                'Total Pelanggan Aktif:',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSizes.sectionGap),

                        SectionCard(
                          title: 'Total Stok Produk',
                          subtitle:
                              'Total: ${productStockDummy.fold<int>(0, (sum, p) => sum + p.stock)} items',
                          child: GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.6,
                            children: productStockDummy.map((p) {
                              return _stockCard(p.name, 'stok: ${p.stock}');
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            AppDrawer(isOpen: isOpen, onToggle: toggleDrawer),
          ],
        ),
      ),
    );
  }

  Widget _stockCard(String name, String stock) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p8,
      ),
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(AppSizes.cardSmallRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: AppTextStyles.subtitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            stock,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
