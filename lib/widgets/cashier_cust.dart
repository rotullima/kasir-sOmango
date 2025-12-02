import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_textStyles.dart';

enum CashierDialogType { payment, addCustomer, editCustomer }

class CashierCustomDialog extends StatelessWidget {
  final CashierDialogType type;
  final VoidCallback? onCancel;
  final VoidCallback onConfirm;

  final String? amountPaid;
  final String? change;

  final TextEditingController? nameController;
  final TextEditingController? emailController;
  final String? initialName;
  final String? initialEmail;

  const CashierCustomDialog({
    super.key,
    required this.type,
    this.onCancel,
    required this.onConfirm,
    this.amountPaid,
    this.change,
    this.nameController,
    this.emailController,
    this.initialName,
    this.initialEmail,
  });

  String get _title {
    switch (type) {
      case CashierDialogType.payment:
        return "Rincian Pembayaran Tunai";
      case CashierDialogType.addCustomer:
        return "Tambah Pelanggan Baru";
      case CashierDialogType.editCustomer:
        return "Edit Pelanggan Baru";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppSizes.shadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _title,
            style: AppTextStyles.subtitle.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          if (type == CashierDialogType.payment) ...[
            _buildReadOnlyField("Uang Tunai:", amountPaid ?? "-"),
            const SizedBox(height: 16),
            _buildReadOnlyField("Kembalian:", change ?? "-"),
          ] else ...[
            _buildLabel("Nama Pelanggan:"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: nameController,
              hintText: "Masukkan nama",
              initialValue: initialName,
            ),
            const SizedBox(height: 20),
            _buildLabel("Email:"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: emailController,
              hintText: "Masukkan email",
              initialValue: initialEmail,
              keyboardType: TextInputType.emailAddress,
            ),
          ],

          const SizedBox(height: 32),

          if (type == CashierDialogType.payment)
            _buildSingleButton()
          else
            _buildTwoButtons(),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? hintText,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final effectiveController =
        controller ?? TextEditingController(text: initialValue);
    if (initialValue != null && controller == null) {
      effectiveController.text = initialValue;
    }

    return TextField(
      controller: effectiveController,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSingleButton() {
    return ElevatedButton(
      onPressed: onConfirm,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textSecondary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check, color: Colors.green),
          SizedBox(width: 8),
          Text("Selesai", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTwoButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textSecondary,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.close_rounded, color: Colors.red),
                SizedBox(width: 6),
                Text("Kembali", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textSecondary,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check, color: Colors.green),
                SizedBox(width: 6),
                Text("Selesai", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
