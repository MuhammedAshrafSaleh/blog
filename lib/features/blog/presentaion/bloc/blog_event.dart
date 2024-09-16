part of 'blog_bloc.dart';

sealed class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

class BlogUploadEvent extends BlogEvent {
  final File image;
  final String title;
  final String content;
  final String poster_id;
  final List<String> topics;

  const BlogUploadEvent({
    required this.image,
    required this.title,
    required this.content,
    required this.poster_id,
    required this.topics,
  });
}

class BlogGetAllBlogsEvent extends BlogEvent {}
