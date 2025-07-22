import 'package:edu_mate/core/routing/routs.dart';
import 'package:edu_mate/features/auth/presentation/pages/login_screen.dart';
import 'package:edu_mate/features/splash/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splashScreen,
    routes: [
      GoRoute(
        path: Routes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
