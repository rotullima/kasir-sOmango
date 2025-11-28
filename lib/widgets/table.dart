import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_textStyles.dart';

class TransactionTable extends StatelessWidget {
  final List<dynamic> data;
  const TransactionTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: AppColors.primary),
          children: [
            _header('No'),
            _header('Nama'),
            _header('Tanggal'),
            _header('Total'),
          ],
        ),
        ...data.map((t) => _row(t.no, t.name, t.date, t.total)),
      ],
    );
  }

  Widget _header(String text) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.p8),
      child: Text(
        text,
        style: AppTextStyles.body.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TableRow _row(String no, String name, String date, String total) {
    return TableRow(
      children: [
        _cell(no),
        _cell(name),
        _cell(date),
        _cell(total),
      ],
    );
  }

  Widget _cell(String text) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.p8),
      child: Text(
        text,
        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
