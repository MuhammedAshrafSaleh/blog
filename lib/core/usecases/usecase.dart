import 'package:dartz/dartz.dart';
import 'package:blog_app/core/errors/failure.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}