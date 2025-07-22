import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthReposirory {
  // This class will handle the authentication logic
  // For example, it can interact with a remote API or local database
  // to manage user authentication state, login, logout, etc.

  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  Future<bool> isAuthenticated();
  Future<void> logout();
}
