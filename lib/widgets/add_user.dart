import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_textStyles.dart';

enum IconSide { left, right }

class AddUserCard extends StatefulWidget {
  final VoidCallback onCancel;
  final ValueChanged<Map<String, dynamic>>
  onCreate; 

  const AddUserCard({
    super.key,
    required this.onCancel,
    required this.onCreate,
  });

  @override
  State<AddUserCard> createState() => _AddUserCardState();
}

class _AddUserCardState extends State<AddUserCard> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  XFile? _picked;
  Uint8List? _pickedBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? img = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (img != null) {
      final bytes = await img.readAsBytes();
      setState(() {
        _picked = img;
        _pickedBytes = bytes;
      });
    }
  }

  void _submit() {
    final name = _emailController.text.trim().isEmpty
        ? 'User'
        : _emailController.text.trim();
    final role = _roleController.text.trim().isEmpty
        ? 'kasir'
        : _roleController.text.trim();
    final imagePath = _picked?.path ?? '';
    widget.onCreate({
      'name': name,
      'role': role,
      'imagePath': imagePath,
      'imageBytes': _pickedBytes,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppSizes.shadow],
        ),
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "DAFTARKAN PENGGUNA BARU",
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            buildOverlayInput(
              controller: _emailController,
              hint: 'Email',
              icon: Icons.person,
              iconSide: IconSide.left,
            ),
            const SizedBox(height: 20),

            buildOverlayInput(
              controller: _passwordController,
              hint: 'Kata kunci',
              icon: Icons.lock,
              obscure: false,
              iconSide: IconSide.right,
            ),
            const SizedBox(height: 20),

            buildOverlayDropdown(
              hint: "Sebagai",
              icon: Icons.badge,
              iconSide: IconSide.left,
              value: _roleController.text.isEmpty ? null : _roleController.text,
              items: const ["kasir", "admin"],
              onChanged: (val) {
                setState(() {
                  _roleController.text = val ?? "";
                });
              },
            ),

            const SizedBox(height: 20),

            buildImagePicker(
              hint: "Profil",
              icon: Icons.photo,
              iconSide: IconSide.right, 
              picked: _picked,
              onTap: _pickImage,
            ),

            const SizedBox(height: 26),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textSecondary,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.close_rounded, color: Colors.red),
                    label: const Text("Kembali"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textSecondary,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.check, color: Colors.green),
                    label: const Text("Selesai"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOverlayInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    IconSide iconSide = IconSide.left,
    bool obscure = false,
  }) {
    final isEmpty = controller.text.isEmpty;

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [AppSizes.shadow],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: controller,
              obscureText: obscure,
              textAlign: isEmpty ? TextAlign.center : TextAlign.center,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
                isCollapsed: true,
                contentPadding: const EdgeInsets.only(top: 11),
              ),
            ),
          ),
        ),

        Positioned(
          left: iconSide == IconSide.left ? 60 : null,
          right: iconSide == IconSide.right ? 60 : null,
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
      ],
    );
  }

  Widget buildOverlayDropdown({
    required String hint,
    required IconData icon,
    required IconSide iconSide,
    required String? value,
    required void Function(String?) onChanged,
    required List<String> items,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [AppSizes.shadow],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  hint,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                isExpanded: true,
                iconSize: 0, 
                alignment: Alignment.center,
                onChanged: onChanged,
                items: items.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Center(
                      child: Text(
                        e,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        Positioned(
          left: iconSide == IconSide.left ? 60 : null,
          right: iconSide == IconSide.right ? 60 : null,
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
      ],
    );
  }

  Widget buildImagePicker({
    required String hint,
    required IconData icon,
    required IconSide iconSide,
    required VoidCallback onTap,
    XFile? picked,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [AppSizes.shadow],
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                picked != null ? picked.name : hint,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          Positioned(
            left: iconSide == IconSide.left ? 60 : null,
            right: iconSide == IconSide.right ? 60 : null,
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
        ],
      ),
    );
  }
}
