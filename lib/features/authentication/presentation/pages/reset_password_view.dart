import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/login_view.dart'
    show LoginView;
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_button.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_input_field.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_main_text.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});
  static const String routeName = 'ResetPasswordView';
  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  GlobalKey<FormState> confirmKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerPassword = TextEditingController();
  TextEditingController textEditingControllerConfirm = TextEditingController();
  bool securedText = true;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Localizations.localeOf(context).languageCode == 'ar'
                    ? 'مرحبًا بعودتك'
                    : 'Welcome back!',
                style: TextStyle(color: Colors.white),
              ),

              backgroundColor: ColorGuide.mainColor,
            ),
          );
          Navigator.pushReplacementNamed(context, LoginView.routeName);
        } else if (state is ResetPasswordFail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is ResetPasswordLoading,
          child: Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenSize.height * 0.071888,
                    left: ScreenSize.width * 0.06046,
                    right: ScreenSize.width * 0.06046,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Image.asset(
                      'assets/back.png',
                      width: ScreenSize.width * 0.0953 * 1.2,
                      height: ScreenSize.height * 0.0439914 * 1.2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.width * 0.0879,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: ScreenSize.height * 0.0890557 * 2.5),
                        CustomMainText(
                          txt:
                              Localizations.localeOf(context).languageCode ==
                                  'ar'
                              ? 'هل نسيت كلمة المرور؟'
                              : 'Forgot Password?',
                        ),

                        SizedBox(height: ScreenSize.height * 0.016094 * 2),
                        Text(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'لا تقلق، يحدث ذلك. من فضلك أدخل البريد الإلكتروني المرتبط بحسابك.'
                              : 'Don\'t worry! It occurs. Please enter the email address linked with your account.',
                          style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: ScreenSize.height * 0.017,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: ScreenSize.height * 0.016094 * 2),
                        CustomInputField(
                          fieldKey: passwordKey,
                          hint:
                              Localizations.localeOf(context).languageCode ==
                                  'ar'
                              ? 'أدخل كلمة المرور الجديدة'
                              : 'Enter your new password',
                          label:
                              Localizations.localeOf(context).languageCode ==
                                  'ar'
                              ? 'كلمة المرور الجديدة'
                              : 'New password',
                          fieldController: textEditingControllerPassword,
                          isPassword: true,
                          isObsecured: securedText,
                          onTap: () {
                            setState(() {
                              securedText = !securedText;
                            });
                          },
                          textInputType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'هذا الحقل مطلوب'
                                  : 'This field is required';
                            } else if (value !=
                                textEditingControllerConfirm.text) {
                              return Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'أعد تأكيد كلمة المرور'
                                  : 'Reconfirm your password';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: ScreenSize.height * 0.026094),
                        CustomInputField(
                          fieldKey: confirmKey,
                          hint:
                              Localizations.localeOf(context).languageCode ==
                                  'ar'
                              ? 'تأكيد كلمة المرور'
                              : 'Confirm your password',
                          label:
                              Localizations.localeOf(context).languageCode ==
                                  'ar'
                              ? 'تأكيد كلمة المرور'
                              : 'Confirm password',
                          fieldController: textEditingControllerConfirm,
                          isPassword: true,
                          isObsecured: securedText,
                          onTap: () {
                            setState(() {
                              securedText = !securedText;
                            });
                          },
                          textInputType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'هذا الحقل مطلوب'
                                  : 'This field is required';
                            } else if (value !=
                                textEditingControllerPassword.text) {
                              return Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'أعد تأكيد كلمة المرور'
                                  : 'Reconfirm your password';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: ScreenSize.height * 0.026094),
                        CustomButton(
                          onTap: () async {
                            if (passwordKey.currentState!.validate() &&
                                confirmKey.currentState!.validate()) {
                              await BlocProvider.of<AuthenticationCubit>(
                                context,
                              ).resetPassword(
                                newPassword: textEditingControllerPassword.text,
                              );
                            }
                          },
                          txt:
                              Localizations.localeOf(context).languageCode ==
                                  'ar'
                              ? 'تأكيد'
                              : 'Send Confirm',
                          active: true,
                          width: ScreenSize.width,
                          height: ScreenSize.height * 0.068,
                        ),

                        SizedBox(height: ScreenSize.height * 0.250557),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              Localizations.localeOf(context).languageCode ==
                                      'ar'
                                  ? 'تذكرت كلمة المرور؟'
                                  : 'Remember Password?',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: ScreenSize.height * 0.02,
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(LoginView.routeName);
                              },
                              child: Text(
                                Localizations.localeOf(context).languageCode ==
                                        'ar'
                                    ? 'تسجيل الدخول'
                                    : 'Login',
                                style: TextStyle(
                                  color: ColorGuide.mainColor,
                                  fontSize: ScreenSize.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenSize.height * 0.0890557),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
