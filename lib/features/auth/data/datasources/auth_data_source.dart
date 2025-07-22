import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
  /// Logs in a user with the provided [email] and [password].

  Future<UserCredential?> login(String email, String password);

  /// Registers a new user with the provided [email] and [password].
  Future<UserCredential> register(String email, String password);

  /// Logs out the current user.
  Future<void> logout();

  /// Checks if the user is currently authenticated.

  Future<bool> isAuthenticated();
}
