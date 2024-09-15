import 'package:dartz/dartz.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/common/entities/user.dart';

abstract interface class AuthRespository {
  Future<Either<Failure, User>> signUpEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginEmailPassword({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, User>> currentUser();
}
