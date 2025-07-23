import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:edu_mate/features/auth/data/repositories/auth_reposirory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  late User user;

  final AuthReposirory _authRepository;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  AuthCubit(this._authRepository) : super(AuthInitial()) {
    // Automatically check authentication when cubit is created
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      if (isAuthenticated) {
        emit(Authenticated(user: FirebaseAuth.instance.currentUser!));
        user = FirebaseAuth.instance.currentUser!;
        log(
          'User is authenticated: ${FirebaseAuth.instance.currentUser?.email}',
        );
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> login() async {
    try {
      emit(AuthLoading());
      final user = await _authRepository.login(
        emailController.text,
        passwordController.text,
      );
      this.user = user;
      emit(Authenticated(user: user));
      clearControllers();
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> register() async {
    try {
      emit(AuthLoading());
      final user = await _authRepository.register(
        emailController.text,
        passwordController.text,
        fullNameController.text,
      );
      Future.delayed(const Duration(seconds: 1));
      this.user = user;
      emit(Authenticated(user: user));
      clearControllers();
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(AuthLoading());
      await _authRepository.logout();
      emit(Unauthenticated());
      clearControllers();
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    fullNameController.clear();
    confirmPasswordController.clear();
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    confirmPasswordController.dispose();
  }
}
