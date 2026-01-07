import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/constants/app_colors.dart';
import '/constants/app_sizes.dart';
import '/constants/app_textStyles.dart';
import '/widgets/app_header.dart';
import '/widgets/app_drawer.dart';
import '/widgets/add_user.dart';
import '../../providers/user_provider.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  bool isOpen = false;
  bool showAddPopup = false;
  final _searchController = TextEditingController();

  void toggleDrawer() => setState(() => isOpen = !isOpen);

  void _openAddPopup() => setState(() => showAddPopup = true);
  void _closeAddPopup() => setState(() => showAddPopup = false);

  void _addUser(Map<String, dynamic> payload) {
    ref.read(createUserProvider(payload));
    setState(() => showAddPopup = false);
  }

  @override
  Widget build(BuildContext context) {
    final petugasAsync = ref.watch(userListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: AppHeader(title: 'PETUGAS', onToggle: toggleDrawer),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: "cari.....",
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _openAddPopup,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: AppColors.textPrimary,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.textPrimary
                            ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.sectionGap),

                Expanded(
                  child: petugasAsync.when(
                    data: (data) {
                      final q = _searchController.text.toLowerCase().trim();
                      final filtered = q.isEmpty
                          ? data
                          : data.where((u) {
                              return (u['nama'] ?? '')
                                  .toString()
                                  .toLowerCase()
                                  .contains(q);
                            }).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 120,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => _buildUserCard(filtered[i]),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text(e.toString())),
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
                    color: Colors.black26,
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

  Widget _buildUserCard(Map<String, dynamic> item) {
    final avatar = item['avatar_url'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
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
            child: avatar != null
                ? Image.network(
                    avatar,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 85,
                    height: 85,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person),
                  ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['nama'] ?? '-', style: AppTextStyles.subtitle.copyWith(color: AppColors.textPrimary)),

              const SizedBox(height: 5),

              Text('Sebagai: ${item['peran']}', style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}
