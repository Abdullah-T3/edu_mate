import 'dart:developer';

import 'package:edu_mate/features/auth/data/datasources/auth_data_source.dart';
import 'package:edu_mate/features/auth/data/repositories/auth_reposirory.dart';
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
  Future<void> login(String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        throw Exception("Username and password cannot be empty");
      } else if (username.length < 3 || password.length < 6) {
        throw Exception(
          "Username must be at least 3 characters and password at least 6 characters",
        );
      } else {
        await _authDataSource.login(username, password);
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
  Future<void> register(String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        throw Exception("Username and password cannot be empty");
      } else if (username.length < 3 || password.length < 6) {
        throw Exception(
          "Username must be at least 3 characters and password at least 6 characters",
        );
      } else {
        await _authDataSource.register(username, password);
      }
    } catch (error) {
      log("Registration failed: $error");
      rethrow;
    }
  }
}
