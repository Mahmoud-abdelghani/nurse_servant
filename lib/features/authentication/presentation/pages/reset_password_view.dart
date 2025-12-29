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
                "Welcome back!",
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
            backgroundColor: Colors.white,
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
                        SizedBox(height: ScreenSize.height * 0.0890557 * 2.5),
                        CustomMainText(txt: 'Forgot Password?'),
                        SizedBox(height: ScreenSize.height * 0.016094 * 2),
                        Text(
                          'Don\'t worry! It occurs. Please enter the email address linked with your account.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenSize.height * 0.017,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: ScreenSize.height * 0.016094 * 2),
                        CustomInputField(
                          fieldKey: passwordKey,
                          hint: "Enter your new password",
                          label: 'new password',
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
                              return 'This field is required';
                            } else if (value !=
                                textEditingControllerConfirm.text) {
                              return 'Reconfirm your password';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: ScreenSize.height * 0.026094),
                        CustomInputField(
                          fieldKey: confirmKey,
                          hint: "Confirm Your Password",
                          label: 'confirm password',
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
                              return 'This field is required';
                            } else if (value !=
                                textEditingControllerPassword.text) {
                              return 'Reconfirm your password';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: ScreenSize.height * 0.026094),
                        CustomButton(
                          onTap: () {
                            if (passwordKey.currentState!.validate() &&
                                confirmKey.currentState!.validate()) {
                              BlocProvider.of<AuthenticationCubit>(
                                context,
                              ).resetPassword(
                                newPassword: textEditingControllerPassword.text,
                              );
                            }
                          },
                          txt: "Send Confirm",
                          active: true,
                          width: ScreenSize.width,
                          height: ScreenSize.height * 0.068,
                        ),

                        SizedBox(height: ScreenSize.height * 0.350557),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Remember Password?",
                              style: TextStyle(
                                color: Colors.black,
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
                                'Login',
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
