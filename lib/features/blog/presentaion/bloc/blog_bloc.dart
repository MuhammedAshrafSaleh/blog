import 'dart:io';

import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs_usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlogUsecase _uploadBlogUsecase;
  final GetAllBlogsUsecase _getAllBlogsUsecase;
  BlogBloc({
    required UploadBlogUsecase uploadBlogUsecase,
    required GetAllBlogsUsecase getAllBlogsUsecase,
  })  : _uploadBlogUsecase = uploadBlogUsecase,
        _getAllBlogsUsecase = getAllBlogsUsecase,
        super(BlogInitialState()) {
    on<BlogEvent>((_, emit) => emit(BlogLoadingState()));
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogGetAllBlogsEvent>(_onGetAllBlog);
  }

  void _onGetAllBlog(
      BlogGetAllBlogsEvent event, Emitter<BlogState> emit) async {
    final result = await _getAllBlogsUsecase(NoParams());

    return result.fold(
      (l) => emit(BlogFailureState(errorMessage: l.message)),
      (blogs) {
        for (var blog in blogs) {
          if (kDebugMode) {
            print(blog.title);
          }
        }
        emit(BlogSuccessGettingBlogsState(blogs: blogs));
      },
    );
  }

  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final result = await _uploadBlogUsecase(
      UploadBlogParms(
        content: event.content,
        image: event.image,
        poster_id: event.poster_id,
        title: event.title,
        topics: event.topics,
      ),
    );

    result.fold(
      (l) {
        if (kDebugMode) {
          print(l.message);
        }
        emit(BlogFailureState(errorMessage: l.message));
      },
      (blog) => emit(BlogSuccessState()),
    );
  }
}
