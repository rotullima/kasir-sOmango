import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/report_service.dart';

class ReportState {
  final double modal;
  final double pendapatan;

  const ReportState({
    this.modal = 0,
    this.pendapatan = 0,
  });

  double get labaRugi => pendapatan - modal;
}

final reportProvider =
    StateNotifierProvider<ReportNotifier, ReportState>(
  (ref) => ReportNotifier(),
);

class ReportNotifier extends StateNotifier<ReportState> {
  ReportNotifier() : super(const ReportState());

  final service = ReportService();

  Future<void> loadReport(bool bulanan) async {
    final modal = await service.getModal(bulanan: bulanan);
    final pendapatan = await service.getPendapatan(bulanan: bulanan);

    state = ReportState(
      modal: modal,
      pendapatan: pendapatan,
    );
  }
}