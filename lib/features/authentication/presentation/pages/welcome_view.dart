import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/login_view.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/register_view.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});
  static const String routeName = 'WelcomeView';
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.width * 0.0879),
        child: Column(
          children: [
            Spacer(),
            Image.asset(
              'assets/pills_1097231 1.png',
              width: ScreenSize.width * 0.47674,
              height: ScreenSize.height * 0.21995,
              fit: BoxFit.fill,
            ),
            Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'مرحبًا بك في'
                  : 'Welcome To',
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: ScreenSize.height * 0.0439914163090129,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "MediMinder",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: ScreenSize.height * 0.0555,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'مساعدك الشخصي لإدارة مواعيد أدويتك.'
                  : 'Your personal assistant for managing your medication schedule.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: ScreenSize.height * 0.01917,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: ScreenSize.height * 0.0643),
            CustomButton(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(LoginView.routeName);
              },
              txt: Localizations.localeOf(context).languageCode == 'ar'
                  ? 'تسجيل الدخول'
                  : 'Log In',
              active: true,
              width: ScreenSize.width,
              height: ScreenSize.height * 0.07,
            ),

            SizedBox(height: ScreenSize.height * 0.01609),
            CustomButton(
              onTap: () {
                Navigator.of(
                  context,
                ).pushReplacementNamed(RegisterView.routeName);
              },
              txt: Localizations.localeOf(context).languageCode == 'ar'
                  ? 'إنشاء حساب'
                  : 'Register',
              active: false,
              width: ScreenSize.width,
              height: ScreenSize.height * 0.07,
            ),

            Spacer(),
          ],
        ),
      ),
    );
  }
}
