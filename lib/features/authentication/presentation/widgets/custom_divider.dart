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
          color: Theme.of(context).dividerColor,
          height: ScreenSize.height * 0.0007,
          width: ScreenSize.width * 0.27,
        ),
        Text(
          Localizations.localeOf(context).languageCode == 'ar' ? 'أو' : 'Or',
          style: TextStyle(color: Theme.of(context).hintColor),
        ),

        Container(
          color: Theme.of(context).dividerColor,
          height: ScreenSize.height * 0.0007,
          width: ScreenSize.width * 0.27,
        ),
      ],
    );
  }
}
