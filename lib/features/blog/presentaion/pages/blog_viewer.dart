import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/core/utls/calculate_reading_time.dart';
import 'package:blog_app/core/utls/format_data.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) => MaterialPageRoute(
      builder: (context) => BlogViewerPage(
            blog: blog,
          ));
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "By ${blog.posterName}",
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "${formatDateDMMMYYYY(blog.updated_at)}. ${calculateReadingTime(content: blog.content)} min",
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  blog.image_url,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                blog.content,
                style: const TextStyle(height: 2, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
