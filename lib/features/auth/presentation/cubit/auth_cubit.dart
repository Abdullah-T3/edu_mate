import 'package:bloc/bloc.dart';
import 'package:edu_mate/features/auth/data/repositories/auth_reposirory.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthReposirory _authRepository;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthCubit(this._authRepository) : super(AuthInitial());
  Future<void> checkAuthentication() async {
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      if (isAuthenticated) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authRepository.login(email, password);
      emit(Authenticated());
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> register(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authRepository.register(email, password);
      emit(Authenticated());
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }
}
