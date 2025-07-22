import 'package:edu_mate/core/di/injection.dart';
import 'package:edu_mate/core/routing/routs.dart';
import 'package:edu_mate/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/courses/presentation/pages/home_screen.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splashScreen,
    redirect: (context, state) {
      final authCubit = getIt<AuthCubit>();
      if (authCubit.state is Authenticated) {
        return Routes.homeScreen;
      } else if (authCubit.state is Unauthenticated) {
        return Routes.loginScreen;
      } else if (authCubit.state is AuthError) {
        return Routes.loginScreen;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.homeScreen,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: Routes.registerScreen,
        builder: (context, state) => RegisterScreen(),
      ),
    ],
  );
}
