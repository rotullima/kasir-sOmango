import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StateProvider<User?>((ref) {
  final user = ref.read(authServiceProvider).getCurrentUser();
  return user;
});

final loginProvider = FutureProvider.family<AuthResponse, Map<String, String>>(
  (ref, credentials) async {
    final authService = ref.read(authServiceProvider);
    final email = credentials['email']!;
    final password = credentials['password']!;

    final response = await authService.signIn(email, password);
    ref.read(authStateProvider.notifier).state =
        authService.getCurrentUser();
    return response;
  },
);

final logoutProvider = Provider((ref) {
  return () async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
    ref.read(authStateProvider.notifier).state = null;
  };
});