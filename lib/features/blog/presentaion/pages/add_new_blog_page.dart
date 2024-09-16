import 'dart:io';
import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/common/widgets/snakebar.dart';
import 'package:blog_app/features/blog/presentaion/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentaion/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:blog_app/core/utls/pick_image.dart';
import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/core/constants/app_strings.dart';
import 'package:blog_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;
  void selectImage() async {
    final pickedImage = await pickGallaryImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      // TODO: you tell the flutter we are in the state of AppUserLoggedInState okay! Get me the user id form this state
      final poster_id =
          (context.read<AppUserCubit>().state as AppUserLoggedInState).user.id;

      context.read<BlogBloc>().add(
            BlogUploadEvent(
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: image!,
              topics: selectedTopics,
              poster_id: poster_id,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarContent(),
      body: _buildBodyContent(),
    );
  }

  _buildAppBarContent() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            uploadBlog();
          },
          icon: const Icon(Icons.done_rounded),
        ),
      ],
    );
  }

  Widget _buildBodyContent() {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogFailureState) {
          showSnackBar(context: context, content: state.errorMessage);
        } else if (state is BlogSuccessState) {
          Navigator.pushAndRemoveUntil(
            context,
            BlogPage.route(),
            (route) => false,
          );
          showSnackBar(
              context: context, content: AppStrings.blogUploadedSuccessfully);
        }
      },
      builder: (context, state) {
        if (state is BlogLoadingState) {
          return const Loader();
        }
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  image != null ? _showImage(image) : _buildSelectImageWidget(),
                  const SizedBox(height: 10),
                  _buildTabsWidget(),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: titleController,
                    text: AppStrings.blogTitle,
                    hasIcon: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '${AppStrings.blogTitle} is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: contentController,
                    text: AppStrings.blogDescription,
                    hasIcon: false,
                    isMaxLines: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '${AppStrings.blogTitle} is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showImage(image) {
    return GestureDetector(
      onTap: selectImage,
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(image!, fit: BoxFit.cover)),
      ),
    );
  }

  Widget _buildSelectImageWidget() {
    return GestureDetector(
      onTap: () {
        selectImage();
      },
      child: DottedBorder(
        radius: const Radius.circular(25),
        color: AppColors.borderColor,
        dashPattern: const [10, 4],
        borderType: BorderType.RRect,
        strokeCap: StrokeCap.round,
        child: const SizedBox(
          height: 150,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open,
                size: 40,
              ),
              SizedBox(height: 15),
              Text(
                AppStrings.selectYourImage,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabsWidget() {
    final categories = [
      AppStrings.blog,
      AppStrings.technology,
      AppStrings.development,
      AppStrings.entertainment,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedTopics.contains(e)) {
                        selectedTopics.remove(e);
                      } else {
                        selectedTopics.add(e);
                      }
                      if (kDebugMode) {
                        print(selectedTopics);
                      }
                    });
                  },
                  child: Chip(
                    label: Text(e),
                    color: selectedTopics.contains(e)
                        ? const WidgetStatePropertyAll(AppColors.gradient1)
                        : const WidgetStatePropertyAll(
                            AppColors.backgroundColor),
                    side: selectedTopics.contains(e)
                        ? null
                        : const BorderSide(
                            color: AppColors.borderColor,
                          ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }
}
