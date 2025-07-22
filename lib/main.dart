import 'package:edu_mate/core/di/injection.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:edu_mate/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu_mate/core/routing/appRouting.dart';
import 'package:edu_mate/core/theme/logic/theme_cubit.dart';

import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/courses/presentation/cubit/courses_cubit.dart';
import 'features/courses/presentation/cubit/search_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
        BlocProvider<CoursesCubit>(create: (context) => getIt<CoursesCubit>()),
        BlocProvider<SearchCubit>(create: (context) => getIt<SearchCubit>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: 'Edu-Mate',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
