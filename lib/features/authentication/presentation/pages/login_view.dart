import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nurse_servant/core/services/supabase_service.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/forgot_password_view.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/register_view.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_button.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_divider.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_google_button.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_input_field.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_main_text.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model.dart';
import 'package:nurse_servant/features/home/presentation/cubit/data_handling_cubit.dart';
import 'package:nurse_servant/features/home/presentation/cubit/load_from_hive_cubit.dart';
import 'package:nurse_servant/features/home/presentation/pages/home_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static const String routeName = 'LoginView';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  bool isPasswordSecured = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DataHandlingCubit, DataHandlingState>(
      listener: (context, state) {
        if (state is CreatingNewUserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is CreatingNewUserSuccess) {
          for (var item in state.jsons) {
            BlocProvider.of<LoadFromHiveCubit>(
              context,
            ).storeInHive(MedicineModel.fromJson(item));
          }

          BlocProvider.of<LoadFromHiveCubit>(context).getDataFromHive();

          Navigator.pushReplacementNamed(context, HomeView.routeName);
        }
      },
      builder: (context, state) {
        return BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationGoogleSuccess || state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    Localizations.localeOf(context).languageCode == 'ar'
                        ? 'مرحبًا بك في Nurse Servant'
                        : 'Welcome to Nurse Servant',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: ColorGuide.mainColor,
                ),
              );
              BlocProvider.of<DataHandlingCubit>(context).creatNewUserOrFetch(
                SupabaseService.supabase.auth.currentUser!.email!,
              );
            } else if (state is AuthenticationGoogleFail) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is LoginFail) {
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
              inAsyncCall:
                  state is AuthenticationGoogleLoading ||
                  state is LoginLoading ||
                  state is CreatingNewUserLoading,
              child: Scaffold(
                body: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenSize.height * 0.071888,
                        left: ScreenSize.width * 0.06046,
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
                            SizedBox(height: ScreenSize.height * 0.0890557 * 2),
                            CustomMainText(
                              txt:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'مرحبًا بعودتك! سعداء برؤيتك مرة أخرى'
                                  : 'Welcome back! Glad to see you, Again!',
                            ),

                            SizedBox(height: ScreenSize.height * 0.016094 * 2),
                            CustomInputField(
                              fieldKey: emailKey,
                              hint:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'أدخل بريدك الإلكتروني'
                                  : 'Enter your email',
                              label:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'البريد الإلكتروني'
                                  : 'Email',
                              fieldController: textEditingControllerEmail,
                              isPassword: false,
                              textInputType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? 'هذا الحقل مطلوب'
                                      : 'This field is required';
                                } else if (!value.contains('@')) {
                                  return Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? 'أدخل بريدًا إلكترونيًا صحيحًا'
                                      : 'Enter a valid email';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: ScreenSize.height * 0.016094),
                            CustomInputField(
                              fieldKey: passwordKey,
                              hint:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'أدخل كلمة المرور'
                                  : 'Enter your password',
                              label:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'كلمة المرور'
                                  : 'Password',

                              fieldController: textEditingControllerPassword,
                              isPassword: true,
                              textInputType: TextInputType.text,
                              isObsecured: isPasswordSecured,
                              onTap: () {
                                setState(() {
                                  isPasswordSecured = !isPasswordSecured;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? 'هذا الحقل مطلوب'
                                      : 'This field is required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: ScreenSize.height * 0.005094),
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(ForgotPasswordView.routeName);
                              },
                              child: Text(
                                Localizations.localeOf(context).languageCode ==
                                        'ar'
                                    ? 'هل نسيت كلمة المرور؟'
                                    : 'Forgot Password?',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: ScreenSize.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            CustomButton(
                              onTap: () async {
                                BlocProvider.of<AuthenticationCubit>(
                                  context,
                                ).login(
                                  email: textEditingControllerEmail.text,
                                  password: textEditingControllerPassword.text,
                                );
                              },
                              txt:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'تسجيل الدخول'
                                  : 'Login',
                              active: true,
                              width: ScreenSize.width,
                              height: ScreenSize.height * 0.068,
                            ),
                            SizedBox(height: ScreenSize.height * 0.016094 * 2),
                            CustomDivider(),
                            SizedBox(height: ScreenSize.height * 0.016094 * 2),
                            CustomGoogleButton(
                              ontap: () {
                                BlocProvider.of<AuthenticationCubit>(
                                  context,
                                ).signInWithGoogle();
                              },
                            ),
                            SizedBox(height: ScreenSize.height * 0.0890557),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? 'ليس لديك حساب؟'
                                      : 'Don’t have an account?',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: ScreenSize.height * 0.017,
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(RegisterView.routeName);
                                  },
                                  child: Text(
                                    Localizations.localeOf(
                                              context,
                                            ).languageCode ==
                                            'ar'
                                        ? 'إنشاء حساب'
                                        : 'Register',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: ScreenSize.height * 0.017,
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
      },
    );
  }
}
