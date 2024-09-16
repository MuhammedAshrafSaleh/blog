import 'dart:io';

import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';

class UploadBlogUsecase implements UseCase<Blog, UploadBlogParms> {
  final BlogRepository repository;
  UploadBlogUsecase({required this.repository});

  @override
  Future<Either<Failure, Blog>> call(params) async {
    return await repository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      poster_id: params.poster_id,
      topics: params.topics,
    );
  }
}

class UploadBlogParms {
  final File image;
  final String title;
  final String content;
  final String poster_id;
  final List<String> topics;

  UploadBlogParms({
    required this.image,
    required this.title,
    required this.content,
    required this.poster_id,
    required this.topics,
  });
}
