import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/constants/app_colors.dart';
import '/constants/app_sizes.dart';
import '/constants/app_textStyles.dart';
import '/widgets/app_header.dart';
import '/widgets/app_drawer.dart';
import '/widgets/add_user.dart';
import '/dummy/user_dummy.dart';
import '/models/user_model.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  bool isOpen = false;
  bool showAddPopup = false;
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    users = List.from(dummyUsers); 
    _searchController.addListener(() {
      setState(() {}); 
    });
  }

  void toggleDrawer() {
    setState(() => isOpen = !isOpen);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserModel> get _filtered {
    final q = _searchController.text.toLowerCase().trim();
    if (q.isEmpty) return users;
    return users.where((u) => u.name.toLowerCase().contains(q) || u.role.toLowerCase().contains(q)).toList();
  }

  void _openAddPopup() {
    setState(() => showAddPopup = true);
  }

  void _closeAddPopup() {
    setState(() => showAddPopup = false);
  }

  void _addUser(Map<String, dynamic> payload) {
    final nextId = users.isEmpty ? 1 : (users.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);
    final imagePath = payload['imagePath'] as String;
    late String finalImagePath;

    if (imagePath.isNotEmpty) {
      finalImagePath = imagePath;
    } else {
      finalImagePath = 'assets/avatar_placeholder.png';
    }

    final newUser = UserModel(
      id: nextId,
      name: payload['name'] as String,
      role: payload['role'] as String,
      imagePath: finalImagePath,
    );

    setState(() {
      users.insert(0, newUser);
      showAddPopup = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p16),
                  child: AppHeader(title: 'PETUGAS', onToggle: toggleDrawer),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 45,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: "cari.....",
                                    hintStyle: TextStyle(color: AppColors.textSecondary),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const Icon(Icons.search, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.p12),
                      GestureDetector(
                        onTap: _openAddPopup,
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.p4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.textPrimary, width: 3),
                          ),
                          child: const Icon(Icons.add, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.sectionGap),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: AppSizes.p16, right: AppSizes.p16, bottom: 120),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _buildUserCard(item);
                    },
                  ),
                ),
              ],
            ),

            AppDrawer(isOpen: isOpen, onToggle: toggleDrawer),

            if (showAddPopup)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                    alignment: Alignment.center,
                    child: AddUserCard(
                      onCancel: _closeAddPopup,
                      onCreate: _addUser,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.p12),
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardSmallRadius),
        boxShadow: [AppSizes.shadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.cardSmallRadius),
            child: _buildAvatar(item),
          ),
          const SizedBox(width: AppSizes.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.subtitle.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sebagai: ${item.role}',
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary.withOpacity(0.85)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(UserModel item) {
    final path = item.imagePath;
    if (path.isEmpty) {
      return Container(
        width: 70,
        height: 70,
        color: Colors.grey[300],
        child: const Icon(Icons.person),
      );
    }

    if (path.startsWith('http')) {
      return Image.network(path, width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
        return Container(width: 70, height: 70, color: Colors.grey[300], child: const Icon(Icons.person));
      });
    }

    if (path.startsWith('assets/')) {
      return Image.asset(path, width: 70, height: 70, fit: BoxFit.cover);
    }

    try {
      final file = File(path);
      return Image.file(file, width: 70, height: 70, fit: BoxFit.cover);
    } catch (e) {
      return Container(width: 70, height: 70, color: Colors.grey[300], child: const Icon(Icons.person));
    }
  }
}
