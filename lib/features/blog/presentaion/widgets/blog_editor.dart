import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  String? Function(String?)? validator;
  BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(hintText: hintText),
      maxLines: null,
    );
  }
}
