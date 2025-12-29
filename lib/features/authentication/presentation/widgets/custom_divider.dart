import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          color: Colors.grey,
          height: ScreenSize.height * 0.0007,
          width: ScreenSize.width * 0.27,
        ),
        Text('Or'),
        Container(
          color: Colors.grey,
          height: ScreenSize.height * 0.0007,
          width: ScreenSize.width * 0.27,
        ),
      ],
    );
  }
}
