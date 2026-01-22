import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomMainText extends StatelessWidget {
  const CustomMainText({super.key, required this.txt});
  final String txt;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: ScreenSize.height * 0.0321,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
