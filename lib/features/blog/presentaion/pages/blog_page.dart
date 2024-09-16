import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/common/widgets/snakebar.dart';
import 'package:blog_app/core/constants/app_strings.dart';
import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/features/blog/presentaion/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentaion/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentaion/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogGetAllBlogsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.blogTitleApp),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: _buildBodyList(),
    );
  }

  Widget _buildBodyList() {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogFailureState) {
          showSnackBar(context: context, content: state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is BlogLoadingState) {
          return const Loader();
        }
        if (state is BlogSuccessGettingBlogsState) {
          return ListView.builder(
            itemCount: state.blogs.length,
            itemBuilder: (context, index) {
              return BlogCard(
                blog: state.blogs[index],
                color: _geColor(index),
              );
            },
          );
        }
        return const Loader();
      },
    );
  }

  Color _geColor(index) {
    if (index % 3 == 0) return AppColors.gradient1;
    if (index % 3 == 1) return AppColors.gradient2;
    if (index % 3 == 2) return AppColors.gradient3;
    return AppColors.errorColor;
  }
}
