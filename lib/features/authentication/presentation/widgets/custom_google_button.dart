import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomGoogleButton extends StatelessWidget {
  const CustomGoogleButton({super.key, required this.ontap});
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:ontap ,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ScreenSize.height * 0.015,
          horizontal: ScreenSize.width * 0.075,
        ),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenSize.height * 0.01),
          color: Colors.transparent,
          border: Border.all(color: Colors.grey),
        ),
        child: Image.asset('assets/Group 162.png'),
      ),
    );
  }
}
