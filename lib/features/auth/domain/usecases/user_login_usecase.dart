import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/repositories/auth_respository.dart';
import 'package:dartz/dartz.dart';

class UserLoginUsecase implements UseCase<User, UserLoginParameters> {
  final AuthRespository authRespository;
  UserLoginUsecase({required this.authRespository});

  @override
  Future<Either<Failure, User>> call(UserLoginParameters params) async {
    return await authRespository.loginEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParameters {
  final String email;
  final String password;
  UserLoginParameters({required this.email, required this.password});
}
