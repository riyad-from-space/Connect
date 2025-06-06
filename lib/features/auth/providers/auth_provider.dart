import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authRepositoryProvider).currentUser;
});

final authControllerProvider = Provider((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authRepository.registerUser(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return await _authRepository.loginUser(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  Future<void> updateCategories(String userId, List<String> categories) async {
    await _authRepository.updateUserCategories(userId, categories);
  }
}
