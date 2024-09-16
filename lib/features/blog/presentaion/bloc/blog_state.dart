part of 'blog_bloc.dart';

sealed class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object> get props => [];
}

final class BlogInitialState extends BlogState {}

final class BlogLoadingState extends BlogState {}

//TODO:  We did not take the blog as variable because its only upload
final class BlogSuccessState extends BlogState {}

final class BlogFailureState extends BlogState {
  final String errorMessage;
  const BlogFailureState({required this.errorMessage});
}

final class BlogSuccessGettingBlogsState extends BlogState {
  final List<Blog> blogs;
  const BlogSuccessGettingBlogsState({required this.blogs});
}
