import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<AuthResponse> registerAdmin(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    if (response.user != null) {
      await _client.from('profil').insert({
        'user_id': response.user!.id,
        'peran': 'admin',
      });
    }
    return response;
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
