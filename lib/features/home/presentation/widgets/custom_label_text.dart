import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomLabelText extends StatelessWidget {
  const CustomLabelText({super.key, required this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenSize.height * 0.01),
      child: Text(
        '$txt*',
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenSize.height * 0.02,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
