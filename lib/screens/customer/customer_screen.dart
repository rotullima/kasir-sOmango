import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/app_textStyles.dart';
import '/constants/app_sizes.dart';

import '/models/customer_screen_model.dart';
import '/providers/customer_provider.dart';

import '/widgets/app_header.dart';
import '/widgets/app_drawer.dart';
import '/widgets/cashier_cust.dart';
import '/widgets/customer_card.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  bool isOpen = false;

  void toggleDrawer() {
    setState(() => isOpen = !isOpen);
  }

  void _openAddCustomer() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: CashierCustomDialog(
          type: CashierDialogType.addCustomer,
          nameController: nameCtrl,
          emailController: emailCtrl,
          onCancel: () => Navigator.pop(context),
          onConfirm: () async {
            final name = nameCtrl.text.trim();
            final email = emailCtrl.text.trim();

            if (name.isEmpty) {
              _showSnackBar("Nama pelanggan tidak boleh kosong");
              return;
            }
            if (email.isEmpty) {
              _showSnackBar("Email tidak boleh kosong");
              return;
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
              _showSnackBar("Format email tidak valid");
              return;
            }

            try {
              await ref
                  .read(customersProvider.notifier)
                  .addCustomer(
                    CustomerModel(
                      name: name,
                      email: email,
                      points: 0,
                      lastTransaction: 0,
                      totalSpent: 0,
                    ),
                  );
              Navigator.pop(context);
              _showSnackBar("Pelanggan berhasil ditambahkan");
            } catch (e) {
              _showSnackBar("Gagal menambahkan pelanggan: ${e.toString()}");
            }
          },
        ),
      ),
    );
  }

  void _openEditCustomer(CustomerModel customer) {
    final nameCtrl = TextEditingController(text: customer.name);
    final emailCtrl = TextEditingController(text: customer.email);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: CashierCustomDialog(
          type: CashierDialogType.editCustomer,
          nameController: nameCtrl,
          emailController: emailCtrl,
          onCancel: () => Navigator.pop(context),
          onConfirm: () async {
            final name = nameCtrl.text.trim();
            final email = emailCtrl.text.trim();

            if (name.isEmpty) {
              _showSnackBar("Nama pelanggan tidak boleh kosong");
              return;
            }
            if (email.isEmpty) {
              _showSnackBar("Email tidak boleh kosong");
              return;
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
              _showSnackBar("Format email tidak valid");
              return;
            }

            try {
              final updated = CustomerModel(
                id: customer.id,
                name: name,
                email: email,
                points: customer.points,
                lastTransaction: customer.lastTransaction,
                totalSpent: customer.totalSpent,
              );
              await ref
                  .read(customersProvider.notifier)
                  .updateCustomer(updated);
              Navigator.pop(context);
              _showSnackBar("Pelanggan berhasil diupdate");
            } catch (e) {
              _showSnackBar("Gagal update pelanggan: ${e.toString()}");
            }
          },
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool success = false}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: success ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p16,
                    vertical: AppSizes.p16,
                  ),
                  child: AppHeader(title: "PELANGGAN", onToggle: toggleDrawer),
                ),

                Expanded(
                  child: customers.when(
                    data: (list) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: _openAddCustomer,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.textSecondary,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [AppSizes.shadow],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: AppColors.textPrimary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Tambah Pelanggan",
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final c = list[index];

                                return CustomerCard(
                                  name: c.name,
                                  email: c.email,
                                  points: c.points,
                                  lastTransaction: c.lastTransaction,
                                  totalSpent: c.totalSpent,
                                  onEdit: () => _openEditCustomer(c),
                                  onDelete: () => ref
                                      .read(customersProvider.notifier)
                                      .deleteCustomer(c.id!),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    error: (e, _) => Center(
                      child: Text(
                        "Error: $e",
                        style: const TextStyle(color: Colors.red),
                      ),
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
}
