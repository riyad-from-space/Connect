import 'package:connect/features/auth/data/models/user_model.dart';
import 'package:connect/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Auth state provider to track current user
final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authRepositoryProvider).currentUser;
});

// Main auth controller provider
final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

// Auth Controller
class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.registerUser(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      throw e;
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.loginUser(
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      throw e;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      throw e;
    }
  }

  Future<void> updateUserCategories(String userId, List<String> categories) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.updateUserCategories(userId, categories);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      throw e;
    }
  }

  Stream<UserModel?> get currentUser => _authRepository.currentUser;
}