import 'package:dartz/dartz.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/repositories/auth_respository.dart';

class UserSignUpUsecase implements UseCase<String, UserSignUpParams> {
  final AuthRespository authRespository;

  UserSignUpUsecase({required this.authRespository});
  @override
  Future<Either<Failure, String>> call(UserSignUpParams params) async {
    return await authRespository.signUpEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;
  const UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
