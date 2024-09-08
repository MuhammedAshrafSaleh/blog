import 'package:blog_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class AuthRespository {
  Future<Either<Failure, String>> signUpEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> loginEmailPassword({
    required String email,
    required String password,
  });
}
