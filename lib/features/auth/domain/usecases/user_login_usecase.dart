import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

class UserLoginUsecase implements UseCase<User, UserLoginParameters> {
  @override
  Future<Either<Failure, dynamic>> call(params) {}
}

class UserLoginParameters {
  final String email;
  final String password;
  UserLoginParameters({required this.email, required this.password});
}
