import 'dart:async';
import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu_mate/core/routing/routs.dart';
import 'package:go_router/go_router.dart';
import 'package:edu_mate/features/auth/presentation/cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _activeDot = 0;
  Timer? _dotTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _activeDot = (_activeDot + 1) % 3;
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!_navigated) {
        _checkAuthAndNavigate();
      }
    });

    Timer(const Duration(seconds: 4), () {
      if (!_navigated) {
        _fallbackNavigation();
      }
    });
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    super.dispose();
  }

  void _checkAuthAndNavigate() async {
    if (!_navigated) {
      _navigated = true;
      _dotTimer?.cancel();

      final authCubit = context.read<AuthCubit>();

      await Future.delayed(const Duration(milliseconds: 500));

      print('Splash: Auth state is ${authCubit.state.runtimeType}');

      if (authCubit.state is Authenticated) {
        print('Splash: Navigating to home screen');
        GoRouter.of(context).go(Routes.homeScreen);
      } else if (authCubit.state is Unauthenticated ||
          authCubit.state is AuthError) {
        print('Splash: Navigating to login screen');
        GoRouter.of(context).go(Routes.loginScreen);
      } else if (authCubit.state is AuthInitial) {
        print('Splash: Auth state is initial, forcing auth check');
        // Force auth check and wait for result
        await authCubit.checkAuthentication();
        await Future.delayed(const Duration(milliseconds: 500));

        if (authCubit.state is Authenticated) {
          print('Splash: After check - Navigating to home screen');
          GoRouter.of(context).go(Routes.homeScreen);
        } else {
          print('Splash: After check - Navigating to login screen');
          GoRouter.of(context).go(Routes.loginScreen);
        }
      } else {
        print('Splash: Unknown auth state, defaulting to login');
        GoRouter.of(context).go(Routes.loginScreen);
      }
    }
  }

  // Fallback navigation in case the main navigation fails
  void _fallbackNavigation() {
    if (!_navigated) {
      print('Splash: Using fallback navigation to login');
      _navigated = true;
      _dotTimer?.cancel();
      GoRouter.of(context).go(Routes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InfoWidget(
        builder: (context, deviceInfo) => SizedBox(
          width: deviceInfo.screenWidth,
          height: deviceInfo.screenHeight,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF754CA3), Color(0xFF677CE7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: deviceInfo.screenWidth * 0.3,
                    height: deviceInfo.screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        deviceInfo.screenWidth * 0.15,
                      ),
                    ),
                    child: Icon(
                      Icons.layers,
                      size: deviceInfo.screenWidth * 0.15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: deviceInfo.screenWidth * 0.05),
                  // App Name
                  Text(
                    'EduMate',
                    style: TextStyle(
                      fontSize: deviceInfo.screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: deviceInfo.screenWidth * 0.02),
                  // Tagline
                  Text(
                    'Learn. Grow. Succeed.',
                    style: TextStyle(
                      fontSize: deviceInfo.screenWidth * 0.06,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: deviceInfo.screenWidth * 0.1),
                  // Animated Page Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => _buildDot(index == _activeDot, deviceInfo),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildDot(bool isActive, Deviceinfo deviceInfo) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: deviceInfo.screenWidth * 0.01),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white38,
        shape: BoxShape.circle,
      ),
    );
  }
}
