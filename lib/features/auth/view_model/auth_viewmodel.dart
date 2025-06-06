import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';
import '../data/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authViewModelProvider = Provider((ref) {
  return AuthViewModel(ref.watch(authRepositoryProvider));
});

class AuthViewModel {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

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

  Stream<UserModel?> get currentUser => _authRepository.currentUser;
}
