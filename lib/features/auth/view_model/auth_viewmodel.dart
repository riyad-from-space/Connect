import 'package:connect/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref)=>AuthRepository());

class AuthViewModel{
  final AuthRepository _authRepository;
  AuthViewModel(this._authRepository);

  //Signup method
  Future<void> signUp(String email, String password) async {
    await _authRepository.signUp(email, password);
  }

  //Login method
  Future <void> login(String email, String password)async {
    await _authRepository.login(email,password);
  }

  //Signout method

  Future<void> logout ()async{
    await _authRepository.logout();
  }
}

final authViewModelProvider = Provider((ref){
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthViewModel(authRepository);
});