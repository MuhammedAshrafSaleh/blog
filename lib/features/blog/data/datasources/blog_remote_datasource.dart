import 'dart:io';

import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDatasource {
  Future<List<BlogModel>> getAllBlogs();
  Future<BlogModel> uploadBlog({required BlogModel blogModel});
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
}

class BlogRemoteDatasourceImpl implements BlogRemoteDatasource {
  // Add Your Dependencies
  final SupabaseClient supabaseClient;
  BlogRemoteDatasourceImpl({required this.supabaseClient});

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles (name)');
      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog)
                .copyWith(posterName: blog['profiles']['name']),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BlogModel> uploadBlog({required BlogModel blogModel}) async {
    try {
      final response = await supabaseClient
          .from('blogs')
          .insert(blogModel.toJson())
          .select();
      return BlogModel.fromJson(response.first);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
