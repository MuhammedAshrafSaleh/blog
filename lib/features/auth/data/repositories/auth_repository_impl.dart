import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/features/auth/domain/repositories/auth_respository.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_sources.dart';

class AuthRepositoryImpl implements AuthRespository {
  // TODO: We Depend on Abstract class not the concrete class
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, UserModel>> loginEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await authRemoteDataSource.loginEmailPassword(
        email: email,
        password: password,
      );
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUpEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    // TODO: We Put Try and Catch Here to Handle Exception That Comes from the authRemoteDataSource
    try {
      final userModel = await authRemoteDataSource.signUpEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> _getUser(Future<UserModel> fn) async {
    try {
      final userModel = await fn;
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
