import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

class AuthViewModel {
  final AuthRepository _authRepository;
  AuthViewModel(this._authRepository);

  // Signup method - return UserCredential
  Future<UserCredential> signUp(String email, String password) async {
    return await _authRepository.signUp(email, password);
  }

  // Login method
  Future<void> login(String email, String password) async {
    await _authRepository.login(email, password);
  }

  // Signout method
  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
}

final authViewModelProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthViewModel(authRepository);
});
