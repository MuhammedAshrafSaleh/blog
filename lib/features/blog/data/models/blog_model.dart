import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.poster_id,
    required super.title,
    required super.content,
    required super.image_url,
    required super.topics,
    required super.updated_at,
    super.posterName,
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
      updated_at: data['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(data['updated_at']),
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': poster_id,
      'title': title,
      'content': content,
      'image_url': image_url,
      'topics': topics,
      'updated_at': updated_at.toIso8601String(),
    };
  }

  // TODO: to be able to change the vaules in the blogmodel
  BlogModel copyWith({
    String? id,
    String? poster_id,
    String? title,
    String? content,
    String? image_url,
    List<String>? topics,
    DateTime? updated_at,
    String? posterName,
  }) {
    return BlogModel(
      id: id ?? this.id,
      poster_id: poster_id ?? this.poster_id,
      title: title ?? this.title,
      content: content ?? this.content,
      image_url: image_url ?? this.image_url,
      topics: topics ?? this.topics,
      updated_at: updated_at ?? this.updated_at,
      posterName: posterName ?? this.posterName,
    );
  }
}
