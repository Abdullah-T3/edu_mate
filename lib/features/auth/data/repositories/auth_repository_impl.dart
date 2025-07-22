import 'dart:developer';

import 'package:edu_mate/features/auth/data/datasources/auth_data_source.dart';
import 'package:edu_mate/features/auth/data/repositories/auth_reposirory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthReposirory)
class AuthRepositoryImpl implements AuthReposirory {
  final AuthDataSource _authDataSource;
  AuthRepositoryImpl(this._authDataSource);
  @override
  Future<bool> isAuthenticated() async {
    return await _authDataSource
        .isAuthenticated()
        .then((value) {
          return value;
        })
        .catchError((error) {
          log("Error checking authentication: $error");
          return false;
        });
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Username and password cannot be empty");
      } else if (email.length < 3 || password.length < 6) {
        throw Exception(
          "Username must be at least 3 characters and password at least 6 characters",
        );
      } else {
        final response = await _authDataSource.login(email, password);
        return response!.user!;
      }
    } catch (error) {
      log("Login failed: $error");
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _authDataSource.logout().catchError((error) {
      log("Logout failed: $error");
    });
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Username and password cannot be empty");
      } else if (email.length < 3 || password.length < 6) {
        throw Exception(
          "Username must be at least 3 characters and password at least 6 characters",
        );
      } else if (!RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(email)) {
        throw Exception("Invalid email format");
      } else if (fullName.isEmpty) {
        throw Exception("Full name cannot be empty");
      } else {
        final response = await _authDataSource.register(
          email,
          password,
          fullName,
        );
        if (response.user == null) {
          throw Exception("Registration failed, please try again");
        }

        return response.user!;
      }
    } catch (error) {
      log("Registration failed: $error");
      rethrow;
    }
  }
}
