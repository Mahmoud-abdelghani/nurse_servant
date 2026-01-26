import 'package:flutter/widgets.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model.dart';
import 'package:nurse_servant/features/home/presentation/pages/medicine_details.dart';

class CustomDatailsRow extends StatelessWidget {
  const CustomDatailsRow({
    super.key,
    required this.txt,
    required this.iconData,
  });
  final String txt;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          iconData,
          color: ColorGuide.mainColor,
          size: ScreenSize.height * 0.03,
          weight: 10,
        ),
        Text(
          txt,
          style: TextStyle(
            color: ColorGuide.mainColor,
            fontWeight: FontWeight.w400,
            fontSize: ScreenSize.height * 0.017,
          ),
        ),
      ],
    );
  }
}
