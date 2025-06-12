import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Create the user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('User creation failed');
      }

      // Create the user data
      final user = UserModel(
        uid: userCredential.user!.uid,
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        selectedTopics: [],
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toMap());

      // Return user model
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to register user');
    } catch (e) {
      throw Exception('Failed to register user');
    }
  }

  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (!doc.exists) throw Exception('User not found');
      return UserModel.fromMap(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to login');
    } catch (e) {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to logout');
    }
  }

  Future<void> updateUserCategories(
      String userId, List<String> categories) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'selectedTopics': categories,
      });
    } catch (e) {
      throw Exception('Failed to update categories');
    }
  }

  Stream<UserModel?> get currentUser {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!);
    });
  }
}