import 'package:edu_mate/core/di/injection.dart';
import 'package:edu_mate/core/routing/routs.dart';
import 'package:edu_mate/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/auth/presentation/pages/profile_screen.dart';
import '../../features/courses/presentation/cubit/courses_cubit.dart';
import '../../features/courses/presentation/cubit/enrolled_courses_cubit.dart';
import '../../features/courses/presentation/cubit/search_cubit.dart';
import '../../features/courses/presentation/pages/home_screen.dart';
import '../../features/courses/presentation/pages/course_details_screen.dart';
import '../../features/courses/presentation/pages/my_courses_screen.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splashScreen,
    redirect: (context, state) {
      final authCubit = getIt<AuthCubit>();

      if (state.matchedLocation == Routes.splashScreen) {
        return null;
      }
      if (authCubit.state is Unauthenticated || authCubit.state is AuthError) {
        if (state.matchedLocation == Routes.homeScreen ||
            state.matchedLocation == Routes.courseDetailsScreen ||
            state.matchedLocation == Routes.enrolledCoursesScreen ||
            state.matchedLocation == Routes.profileScreen) {
          return Routes.loginScreen;
        }
        return null;
      }

      if (authCubit.state is Authenticated) {
        if (state.matchedLocation == Routes.loginScreen ||
            state.matchedLocation == Routes.registerScreen ||
            state.matchedLocation == Routes.splashScreen) {
          return Routes.homeScreen;
        }
        return null;
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
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<SearchCubit>(
              create: (context) => getIt<SearchCubit>(),
            ),
            BlocProvider<CoursesCubit>(
              create: (context) => getIt<CoursesCubit>()..fetchCourses(),
            ),
          ],
          child: HomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.registerScreen,
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/profileScreen',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.courseDetailsScreen,
        builder: (context, state) {
          final course = state.extra as Map<String, dynamic>;
          return CourseDetailsScreen(course: course['course']);
        },
      ),
      GoRoute(
        path: Routes.enrolledCoursesScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                getIt<EnrolledCoursesCubit>()..fetchEnrolledCourses(),
            child: MyCoursesScreen(),
          );
        },
      ),
    ],
  );
}
