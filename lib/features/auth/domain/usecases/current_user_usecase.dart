import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/repositories/auth_respository.dart';
import 'package:dartz/dartz.dart';

class CurrentUserUsecase implements UseCase<User, NoParams> {
  final AuthRespository respository;
  CurrentUserUsecase({required this.respository});
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await respository.currentUser();
  }
}
