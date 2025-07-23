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
    // Start the dot animation timer
    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _activeDot = (_activeDot + 1) % 3;
      });
    });

    // Wait for splash animation
    Future.delayed(const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (!_navigated) {
          _navigated = true;
          _dotTimer?.cancel();

          if (state is Authenticated) {
            GoRouter.of(context).go(Routes.homeScreen);
          } else if (state is Unauthenticated || state is AuthError) {
            GoRouter.of(context).go(Routes.loginScreen);
          }
        }
      },
      child: Scaffold(
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
