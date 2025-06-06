import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> registerUser({
    required String name,
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
        throw Exception('Failed to create user account');
      }

      // Create the user data
      final userData = {
        'id': userCredential.user!.uid,
        'name': name,
        'email': email,
        'selectedCategories': <String>[],
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);

      // Return user model
      return UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        selectedCategories: [],
        createdAt: DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException in registerUser: ${e.code} - ${e.message}');
      throw Exception(e.message ?? 'Failed to register user');
    } catch (e) {
      print('Error in registerUser: $e');
      throw Exception('Failed to register user: $e');
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

      if (userCredential.user == null) {
        throw Exception('Failed to sign in');
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // If user document doesn't exist, create it
        final userData = {
          'id': userCredential.user!.uid,
          'name': email.split('@')[0], // Fallback name
          'email': email,
          'selectedCategories': <String>[],
          'createdAt': DateTime.now().toIso8601String(),
        };
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);
        return UserModel.fromMap(userData);
      }

      final data = userDoc.data() ?? {};
      data['id'] = userCredential.user!.uid; // Ensure ID is set

      return UserModel.fromMap(data);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException in loginUser: ${e.code} - ${e.message}');
      throw Exception(e.message ?? 'Failed to login');
    } catch (e) {
      print('Error in loginUser: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error in logout: $e');
      throw Exception('Failed to logout: $e');
    }
  }

  Future<void> updateUserCategories(
      String userId, List<String> categories) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'selectedCategories': categories,
      });
    } catch (e) {
      print('Error in updateUserCategories: $e');
      throw Exception('Failed to update categories: $e');
    }
  }

  Stream<UserModel?> get currentUser {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // Create user document if it doesn't exist
          final userData = {
            'id': user.uid,
            'name': user.email?.split('@')[0] ?? 'User',
            'email': user.email ?? '',
            'selectedCategories': <String>[],
            'createdAt': DateTime.now().toIso8601String(),
          };
          await _firestore.collection('users').doc(user.uid).set(userData);
          return UserModel.fromMap(userData);
        }

        final data = userDoc.data() ?? {};
        data['id'] = user.uid; // Ensure ID is set
        return UserModel.fromMap(data);
      } catch (e) {
        print('Error in currentUser stream: $e');
        return null;
      }
    });
  }
}
