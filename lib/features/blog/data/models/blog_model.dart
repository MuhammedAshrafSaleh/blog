import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.poster_id,
    required super.title,
    required super.content,
    required super.image_url,
    required super.topics,
    required super.update_at,
  });
  factory BlogModel.fromJson(Map<String, dynamic> data) {
    return BlogModel(
      id: data['id'] as String,
      poster_id: data['poster_id'] as String,
      title: data['title'] as String,
      content: data['content'] as String,
      image_url: data['image_url'] as String,
      //TODO: Important Conversion
      topics: List<String>.from(data['topics'] ?? []),
      update_at: data['update_at'] == null
          ? DateTime.now()
          : DateTime.parse(data['update_at']),
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': poster_id,
      'title': title,
      'content': content,
      'imageUrl': image_url,
      'topics': topics,
      'update_at': update_at.toIso8601String(),
    };
  }
}
