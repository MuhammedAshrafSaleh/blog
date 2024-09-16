import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repositories/auth_respository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs_usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';
import 'package:blog_app/features/blog/presentaion/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    anonKey: AppSecrets.supabaseAnonKey,
    url: AppSecrets.supabaseUrl,
  );
  // RegisterFactory -> Use it when you need to return a new instance of the service
  // RegisterLazySingleton -> Use if when you need to return the same instance
  sl.registerLazySingleton<SupabaseClient>(() => supabase.client);
  // Core
  sl.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  sl
    // DataSource
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: sl(),
      ),
    )
    // Repositories
    ..registerFactory<AuthRespository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUpUsecase(authRespository: sl()),
    )
    ..registerFactory(
      () => UserLoginUsecase(authRespository: sl()),
    )
    ..registerFactory(
      () => CurrentUserUsecase(respository: sl()),
    )
    // AuthBloc
    ..registerLazySingleton(
      () => AuthBloc(
          userSignUpUsecase: sl(),
          userLoginUsecase: sl(),
          currentUser: sl(),
          appUserCubit: sl()),
    );
}

void _initBlog() {
  // 1.RemoteDataSources <Type>
  // 2.Repositories <Type>
  // 3.UseCases
  // 4.Bloc (Singleton)
  sl
    ..registerFactory<BlogRemoteDatasource>(
      () => BlogRemoteDatasourceImpl(
        supabaseClient: sl(),
      ),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        remoteDatasource: sl(),
      ),
    )
    ..registerFactory(
      () => UploadBlogUsecase(
        repository: sl(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogsUsecase(
        repository: sl(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlogUsecase: sl(),
        getAllBlogsUsecase: sl(),
      ),
    );
}
