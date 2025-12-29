import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDateTime extends StatelessWidget {
  const CustomDateTime({
    super.key,
    required this.onDateChange,
    required this.cupertinoDatePickerMode,
  });
  final Function(DateTime) onDateChange;
  final CupertinoDatePickerMode cupertinoDatePickerMode;
  @override
  Widget build(BuildContext context) {
    return CupertinoDatePicker(
      selectionOverlayBuilder:
          (context, {required columnCount, required selectedIndex}) =>
              Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
      onDateTimeChanged: onDateChange,
      backgroundColor: Colors.white,
      initialDateTime: DateTime.now(),
      mode: cupertinoDatePickerMode,
      use24hFormat: true,
    );
  }
}
