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
    try {
      await _authRepository.registerUser(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        username: username,
      );
    } catch (e) {
      print('ERROR SIGNING UP: \\${e.toString()}');
      throw Exception('Failed to sign up. Please try again.');
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _authRepository.loginUser(
        email: email,
        password: password,
      );
    } catch (e) {
      print('ERROR LOGGING IN: \\${e.toString()}');
      throw Exception('Failed to login. Please try again.');
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      print('ERROR LOGGING OUT: \\${e.toString()}');
      throw Exception('Failed to logout. Please try again.');
    }
  }
}
