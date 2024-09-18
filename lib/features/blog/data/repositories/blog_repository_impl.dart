import 'dart:io';

import 'package:blog_app/core/constants/app_strings.dart';
import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_datasource.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final InternetConnection connectionChecker;
  final BlogRemoteDatasource remoteDatasource;
  final BlogLocalDatasource localDatasource;
  BlogRepositoryImpl({
    required this.connectionChecker,
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String poster_id,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetAccess)) {
        return const Left(Failure(message: AppStrings.noInternetConnection));
      }
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
      if (!await connectionChecker.hasInternetAccess) {
        final blogs = localDatasource.loadBlogs();
        return Right(blogs);
      }
      final blogs = await remoteDatasource.getAllBlogs();
      localDatasource.uploadLocalBlogs(
          blogs:
              blogs); // When InternetConnectoin Upload Last Blogs to the hive DB
      return Right(blogs);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
