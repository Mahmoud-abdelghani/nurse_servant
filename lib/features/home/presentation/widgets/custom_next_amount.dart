import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomNextAmount extends StatelessWidget {
  const CustomNextAmount({super.key, required this.nextAmount});
  final String nextAmount;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: ScreenSize.height * 0.13,
      backgroundColor: Color(0xffEFFAFF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/caps7_9dsddssd 1.png',
            height: ScreenSize.height * 0.05,
            width: ScreenSize.width * 0.2,
            fit: BoxFit.contain,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenSize.height * 0.0554,
                  ),
                ),
                TextSpan(
                  text: '/$nextAmount',
                  style: TextStyle(
                    color: ColorGuide.mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenSize.height * 0.0554,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Tuesday',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: ScreenSize.height * 0.023,
            ),
          ),
        ],
      ),
    );
  }
}
