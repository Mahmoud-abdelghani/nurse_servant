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
    required this.nextDose,
  });
  final String title;
  final int amount;
  final String type;
  final String dose;
  final String nextDose;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: ScreenSize.height * 0.025,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Icon(
        Icons.info,
        color: Theme.of(context).primaryColorLight,
        size: ScreenSize.height * 0.035,
      ),
      subtitle: Text(
        '$amount $type, $dose',
        style: TextStyle(color: Theme.of(context).dividerColor),
      ),
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
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(ScreenSize.height * 0.01),
        ),
        padding: EdgeInsets.all(5),

        child: Text(
          nextDose,
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
