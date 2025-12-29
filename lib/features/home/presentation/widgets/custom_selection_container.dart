import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomSelectionContainer extends StatelessWidget {
  const CustomSelectionContainer({
    super.key,
    required this.mainColor,
    required this.txt,
    required this.iconData,
  });
  final Color mainColor;
  final String txt;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.width * 0.055,
        vertical: ScreenSize.height * 0.019,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: mainColor),
        borderRadius: BorderRadius.circular(ScreenSize.height * 0.015),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            txt,
            style: TextStyle(
              color: mainColor,
              fontSize: ScreenSize.height * 0.02,
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(iconData, size: ScreenSize.height * 0.025, color: mainColor),
        ],
      ),
    );
  }
}
