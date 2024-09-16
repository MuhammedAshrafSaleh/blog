import 'package:blog_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  final Color color1, color2;
  const Loader({
    super.key,
    this.color1 = AppColors.gradient1,
    this.color2 = AppColors.gradient2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? color1 : color2,
            ),
          );
        },
      ),
    );
  }
}
