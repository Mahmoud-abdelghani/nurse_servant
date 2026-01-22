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
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 18,
          ),
        ),
      ),
      child: CupertinoDatePicker(
        selectionOverlayBuilder:
            (context, {required columnCount, required selectedIndex}) =>
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                ),
        onDateTimeChanged: onDateChange,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        initialDateTime: DateTime.now(),
        mode: cupertinoDatePickerMode,
        use24hFormat: true,
      ),
    );
  }
}
