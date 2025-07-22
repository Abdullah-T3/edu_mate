import 'package:edu_mate/core/routing/routs.dart';
import 'package:flutter/material.dart';

class AppRouts {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
      case Routes.forgotPassScreen:
      case Routes.homeScreen:
      case Routes.profileScreen:
      case Routes.verifyOtpScreen:
      case Routes.restPasswordScreen:
      case Routes.otpExpiredScreen:
      default:
        return null;
    }
  }
}
