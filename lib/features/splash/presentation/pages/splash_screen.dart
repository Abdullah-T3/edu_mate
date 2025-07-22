import 'dart:async';
import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:edu_mate/core/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:edu_mate/core/routing/routs.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _activeDot = 0;
  Timer? _dotTimer;
  Timer? _navTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // Start the dot animation timer and navigation timer
    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _activeDot = (_activeDot + 1) % 3;
      });
    });
    // Navigate to login screen after 4 seconds
    _navTimer = Timer(const Duration(seconds: 4), () {
      _dotTimer?.cancel();
      if (mounted && !_navigated) {
        _navigated = true;
        GoRouter.of(context).go(Routes.loginScreen);
      }
    });
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    _navTimer?.cancel();
    super.dispose();
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
