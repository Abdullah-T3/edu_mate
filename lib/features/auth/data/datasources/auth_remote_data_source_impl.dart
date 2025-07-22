import 'package:edu_mate/features/auth/data/datasources/auth_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthDataSource)
class AuthRemoteDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> isAuthenticated() {
    return _firebaseAuth.currentUser != null
        ? Future.value(true)
        : Future.value(false);
  }

  @override
  Future<UserCredential?> login(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return _firebaseAuth.signOut().catchError((error) {});
  }

  @override
  Future<UserCredential> register(
    String email,
    String password,
    String fullName,
  ) async {
    final response = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (response.user != null) {
      response.user!.updateProfile(displayName: fullName).catchError((error) {
        throw Exception("Failed to create user : $error");
      });
      return response;
    } else {
      throw Exception("Registration failed");
    }
  }
}
