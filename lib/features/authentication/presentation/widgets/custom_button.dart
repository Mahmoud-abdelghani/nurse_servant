import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap, required this.txt, required this.active, required this.width, required this.height});
  final VoidCallback onTap;
  final String txt;
  final bool active;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth:width ,
      height: height,
      onPressed: onTap,
      color: active ? ColorGuide.mainColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenSize.height * 0.02),
        side: BorderSide(color: ColorGuide.mainColor),
      ),
      child: Text(
        txt,
        style: TextStyle(
          fontSize: ScreenSize.height * 0.025,
          fontWeight: FontWeight.bold,
          color: active ? Colors.white : ColorGuide.mainColor,
        ),
      ),
    );
  }
}
