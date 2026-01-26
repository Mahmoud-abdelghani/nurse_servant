import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomGoogleButton extends StatelessWidget {
  const CustomGoogleButton({super.key, required this.ontap});
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ScreenSize.height * 0.02,
          horizontal: ScreenSize.width * 0.1,
        ),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenSize.height * 0.01),
          color: Colors.transparent,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/icons8-google-48 1.png'),
            Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'تسجيل الدخول باستخدام جوجل'
                  : 'Sign in with Google',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: ScreenSize.height * 0.017,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
