import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repositories/auth_respository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    anonKey: AppSecrets.supabaseAnonKey,
    url: AppSecrets.supabaseUrl,
  );
  // RegisterFactory -> Use it when you need to return a new instance of the service
  // RegisterLazySingleton -> Use if when you need to return the same instance
  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);
  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator
    // DataSource
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<AuthRespository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUpUsecase(authRespository: serviceLocator()),
    )
    ..registerFactory(
      () => UserLoginUsecase(authRespository: serviceLocator()),
    )
    ..registerFactory(
      () => CurrentUserUsecase(respository: serviceLocator()),
    )
    // AuthBloc
    ..registerLazySingleton(
      () => AuthBloc(
          userSignUpUsecase: serviceLocator(),
          userLoginUsecase: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator()),
    );
}
