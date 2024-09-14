import 'package:blog_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      chipTheme: const ChipThemeData(
        side: BorderSide.none,
        color: WidgetStatePropertyAll(AppColors.backgroundColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(27),
        enabledBorder: _border(),
        focusedBorder: _border(),
      ));

  static _border({Color color = AppColors.borderColor}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: color,
          width: 2,
        ),
      );
}
