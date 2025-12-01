import 'package:flutter/material.dart';
import 'package:kasir_s0mango/screens/product/product_screen.dart';
import 'package:kasir_s0mango/screens/report/report_screen.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../services/auth_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/user/user_screen.dart';
import '/screens/dashboard_screen.dart';
import '../screens/cashier/cashier_screen.dart';

class AppDrawer extends StatelessWidget {
  final bool isOpen;
  final VoidCallback? onToggle;

  const AppDrawer({super.key, required this.isOpen, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      top: 12,
      left: isOpen ? 9 : -80,
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [AppSizes.shadow],
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: const Icon(
                Icons.chevron_left,
                size: AppSizes.iconSmall,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              },
              child: Icon(Icons.home_outlined, color: AppColors.textPrimary),
            ),

            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductScreen(),
                  ),
                );
              },
              child: Icon(Icons.grid_view, color: AppColors.textPrimary),
            ),

            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersScreen()),
                );
              },
              child: Icon(Icons.person_add_alt, color: AppColors.textPrimary),
            ),

            SizedBox(height: 20),
            Icon(Icons.add_circle_outline, color: AppColors.textPrimary),
            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CashierScreen()),
                );
              },
              child: Icon(Icons.shopping_cart_outlined, color: AppColors.textPrimary),
            ),

            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportScreen()),
                );
              },
              child: Icon(Icons.receipt_long, color: AppColors.textPrimary),
            ),

            SizedBox(height: 20),

            GestureDetector(
              onTap: () async {
                await AuthService().signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Icon(Icons.logout, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
