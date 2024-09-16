import 'dart:io';

import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDatasource remoteDatasource;
  BlogRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String poster_id,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        poster_id: poster_id,
        title: title,
        content: content,
        image_url: 'image_url',
        topics: topics,
        updated_at: DateTime.now(),
      );
      final image_url =
          await remoteDatasource.uploadBlogImage(image: image, blog: blogModel);
      blogModel = blogModel.copyWith(image_url: image_url);
      final uploadedBlog =
          await remoteDatasource.uploadBlog(blogModel: blogModel);
      return Right(uploadedBlog);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      final blogs = await remoteDatasource.getAllBlogs();
      return Right(blogs);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
