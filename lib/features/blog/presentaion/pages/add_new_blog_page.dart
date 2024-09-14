import 'package:blog_app/core/constants/app_strings.dart';
import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:blog_app/features/blog/presentaion/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController descriptionController = TextEditingController();
  List<String> selectedTopics = [];
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
          onPressed: () {},
          icon: const Icon(Icons.done_rounded),
        ),
      ],
    );
  }

  Widget _buildBodyContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSelectImageWidget(),
            const SizedBox(height: 10),
            _buildTabsWidget(),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: titleController,
              text: AppStrings.blogTitle,
              hasIcon: false,
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 10),
            BlogEditor(
              controller: descriptionController,
              hintText: AppStrings.blogDescription,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectImageWidget() {
    return DottedBorder(
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
    descriptionController.dispose();
  }
}
