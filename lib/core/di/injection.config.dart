// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
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
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i717.AuthDataSource>(
      () => _i43.AuthRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i875.AuthReposirory>(
      () => _i215.AuthRepositoryImpl(gh<_i717.AuthDataSource>()),
    );
    gh.factory<_i437.AuthCubit>(
      () => _i437.AuthCubit(gh<_i875.AuthReposirory>()),
    );
    return this;
  }
}
