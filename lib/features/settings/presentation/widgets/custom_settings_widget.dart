import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomSettingsWidget extends StatelessWidget {
  const CustomSettingsWidget({
    super.key,
    required this.iconDataLeading,
    required this.title,
    required this.subtitle, this.widgetTrailing,
 
  });
  final IconData iconDataLeading;
  final String title;
  final String subtitle;
  final Widget? widgetTrailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconDataLeading,
        color: Theme.of(context).primaryColorLight,
        size: ScreenSize.height * 0.045,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: ScreenSize.height * 0.025,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: ScreenSize.height * 0.018,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: widgetTrailing,
    );
  }
}
