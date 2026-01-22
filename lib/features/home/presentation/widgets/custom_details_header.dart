import 'package:flutter/material.dart' show Colors, IconButton, Icons, Theme;
import 'package:flutter/widgets.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomDetailsHeader extends StatelessWidget {
  const CustomDetailsHeader({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.info,
          color: Theme.of(context).primaryColorLight,
          size: ScreenSize.height * 0.055,
        ),
        IconButton(
          onPressed: onTap,
          icon: Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: ScreenSize.height * 0.055,
          ),
        ),
      ],
    );
  }
}
