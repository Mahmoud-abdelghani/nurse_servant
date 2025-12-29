import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomMedicineLabel extends StatelessWidget {
  const CustomMedicineLabel({
    super.key,
    required this.title,
    required this.amount,
    required this.type,
    required this.dose,
    required this.alarmAt,
  });
  final String title;
  final int amount;
  final String type;
  final String dose;
  final String alarmAt;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(ScreenSize.height * 0.015),
      //   side: BorderSide(color: Colors.grey),
      // ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenSize.height * 0.025,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Icon(
        Icons.info,
        color: Colors.amber,
        size: ScreenSize.height * 0.035,
      ),
      subtitle: Text('$amount $type, $dose'),
      trailing: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(51, 25, 111, 176),
              offset: Offset(0, 2),
              blurStyle: BlurStyle.outer,
              spreadRadius: 1,
            ),
          ],
          color: ColorGuide.mainColor,
          borderRadius: BorderRadius.circular(ScreenSize.height * 0.01),
        ),
        padding: EdgeInsets.all(5),

        child: Text(
          alarmAt,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ScreenSize.height * 0.02,
          ),
        ),
      ),
    );
  }
}
