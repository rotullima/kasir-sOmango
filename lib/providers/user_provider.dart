import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_service.dart';

final userServiceProvider = Provider((ref) {
  return UserService();
});

final userListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.read(userServiceProvider);
  return service.getUser();
});

final createUserProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, payload) async {
  final service = ref.read(userServiceProvider);

  await service.createUser(
  nama: payload['nama'],
  email: payload['email'],
  password: payload['password'],
  role: payload['role'],
  avatarBytes: payload['imageBytes'],
);


    ref.invalidate(userListProvider);
});