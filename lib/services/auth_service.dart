import 'package:supabase_flutter/supabase_flutter.dart';
import '/config/supabase_config.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<String?> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        return 'Login failed. Incorrect email or password.';
      }
      return null; // null = sukses
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'An error occurred while logging in.';
    }
  }


  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String peran, 
    String? avatarUrl,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _client.from('profil').insert({
          'user_id': response.user!.id,
          'peran': peran,
          'avatar_url': avatarUrl,
        });

        return {'error': false, 'message': 'User baru berhasil dibuat'};
      } else {
        return {'error': true, 'message': 'Gagal membuat user baru'};
      }
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  Future<bool> isAdmin() async {
    final user = _client.auth.currentUser;
    if (user == null) return false;

    final data = await _client
        .from('profil')
        .select('peran')
        .eq('user_id', user.id)
        .maybeSingle();

    return data?['peran'] == 'admin';
  }
}
