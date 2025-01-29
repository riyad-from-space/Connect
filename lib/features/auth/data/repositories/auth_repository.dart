import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Signup method - now handles existing user error
  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('This email is already registered. Please log in.');
      }
      throw Exception(e.message ?? 'Signup failed.');
    }
  }

  // Login method
  Future<void> login(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Signout method
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;
}
