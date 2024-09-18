import 'package:blog_app/core/constants/app_strings.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/features/auth/domain/repositories/auth_respository.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRespository {
  // TODO: We Depend on Abstract class not the concrete class
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, UserModel>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;
        if (session == null) {
          return const Left(Failure(message: AppStrings.userIsNotLoggedIn));
        }
        return Right(
          UserModel(email: session.user.email!, id: session.user.id, name: ''),
        );
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return const Left(Failure(message: 'User not logged in!'));
      }
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      fn: () async => await remoteDataSource.loginEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, UserModel>> signUpEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      fn: () async => await remoteDataSource.signUpEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  // TODO: We Put Try and Catch Here to Handle Exception That Comes from the authRemoteDataSource
  Future<Either<Failure, UserModel>> _getUser({
    required Future<UserModel> Function() fn,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return const Left(Failure(message: AppStrings.noInternetConnection));
      }
      final userModel = await fn();
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
