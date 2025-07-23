// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:edu_mate/core/di/di_modules.dart' as _i951;
import 'package:edu_mate/core/network/dio_client.dart' as _i761;
import 'package:edu_mate/features/auth/data/datasources/auth_data_source.dart'
    as _i717;
import 'package:edu_mate/features/auth/data/datasources/auth_remote_data_source_impl.dart'
    as _i43;
import 'package:edu_mate/features/auth/data/repositories/auth_reposirory.dart'
    as _i875;
import 'package:edu_mate/features/auth/data/repositories/auth_repository_impl.dart'
    as _i215;
import 'package:edu_mate/features/auth/presentation/cubit/auth_cubit.dart'
    as _i437;

import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/courses/data/datasource/courses_remote_datasource.dart'
    as _i915;
import '../../features/courses/data/repository/course_repository.dart' as _i304;
import '../../features/courses/data/repository/course_repositrory_impl.dart'
    as _i130
    show CourseRepositroryImpl;
import '../../features/courses/presentation/cubit/courses_cubit.dart' as _i94;
import '../../features/courses/presentation/cubit/search_cubit.dart' as _i613;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i613.SearchCubit>(() => _i613.SearchCubit());
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i761.DioClient>(() => registerModule.dioClient());
    gh.lazySingleton<_i717.AuthDataSource>(
      () => _i43.AuthRemoteDataSourceImpl(),
    );
    gh.factory<_i915.CoursesRemoteDatasource>(
      () => _i915.CoursesRemoteDatasource(gh<_i761.DioClient>()),
    );
    gh.lazySingleton<_i875.AuthReposirory>(
      () => _i215.AuthRepositoryImpl(gh<_i717.AuthDataSource>()),
    );
    gh.factory<_i130.CourseRepositroryImpl>(
      () => _i130.CourseRepositroryImpl(gh<_i915.CoursesRemoteDatasource>()),
    );
    gh.factory<_i437.AuthCubit>(
      () => _i437.AuthCubit(gh<_i875.AuthReposirory>()),
    );
    gh.lazySingleton<_i304.CourseRepository>(
      () => registerModule.courseRepository(gh<_i130.CourseRepositroryImpl>()),
    );
    gh.factory<_i94.CoursesCubit>(
      () => _i94.CoursesCubit(gh<_i304.CourseRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i951.RegisterModule {}
