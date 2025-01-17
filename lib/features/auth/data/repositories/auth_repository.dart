import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   //Signup method
  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  //Login method
  Future <void> login(String email, String password)async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  //Signout method

  Future<void> logout ()async{
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;

}
