import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// GET semua petugas
  Future<List<Map<String, dynamic>>> getUser() async {
    final res = await _supabase
        .from('profil')
        .select('user_id, nama, peran, avatar_url')
        .order('updated_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  /// CREATE petugas + upload avatar
  Future<void> createUser({
    required String nama,
    required String email,
    required String password,
    required String role,
    Uint8List? avatarBytes,
  }) async {
    // 1. create auth user
    final authRes = await _supabase.auth.admin.createUser(
      AdminUserAttributes(email: email, password: password, emailConfirm: true),
    );

    final userId = authRes.user!.id;
    String? avatarUrl;

    // 2. upload avatar (kalau ada)
    if (avatarBytes != null) {
      final filePath = '$userId/avatar.png';

      await _supabase.storage
          .from('profil')
          .uploadBinary(
            filePath,
            avatarBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      avatarUrl = _supabase.storage.from('profil').getPublicUrl(filePath);
    }

    // 3. insert profil
    await _supabase.from('profil').insert({
      'user_id': userId,
      'nama': nama,
      'peran': role,
      'avatar_url': avatarUrl,
    });
  }
}
