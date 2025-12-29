import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomImageButton extends StatelessWidget {
  const CustomImageButton({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
     path ,
      width: ScreenSize.width * 0.15,
      height: ScreenSize.height * 0.07,
      fit: BoxFit.contain,
    );
  }
}
