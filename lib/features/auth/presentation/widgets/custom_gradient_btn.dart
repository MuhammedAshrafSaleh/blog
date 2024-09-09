import 'package:blog_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomGradientBtn extends StatelessWidget {
  final String buttonText;
  void Function()? onPressed;
  CustomGradientBtn({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [AppColors.gradient1, AppColors.gradient2]),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: AppColors.transparentColor,
          shadowColor: AppColors.transparentColor,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
