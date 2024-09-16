import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllBlogsUsecase implements UseCase<List<Blog>, NoParams> {
  final BlogRepository repository;
  GetAllBlogsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<Blog>>> call(params) async {
    return await repository.getAllBlogs();
  }
}
