import 'package:connect/features/auth/data/models/user_model.dart';
import 'package:connect/features/auth/data/repositories/auth_repository.dart';

class AuthViewModel {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
  }) async {
    await _authRepository.registerUser(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      username: username,
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
}