class Blog {
  final String id;
  final String poster_id;
  final String title;
  final String content;
  final String image_url;
  final List<String> topics;
  final DateTime update_at;

  Blog({
    required this.id,
    required this.poster_id,
    required this.title,
    required this.content,
    required this.image_url,
    required this.topics,
    required this.update_at,
  });
}
