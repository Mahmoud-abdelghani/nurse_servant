import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/login_view.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/reset_password_view.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_button.dart'
    show CustomButton;
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_input_field.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_main_text.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});
  static const String routeName = 'ForgotPasswordView';

  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is PasswordResetConfirmSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Don't worry almost there",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: ColorGuide.mainColor,
            ),
          );
          Navigator.pushNamed(context, ResetPasswordView.routeName);
        } else if (state is PasswordResetConfirmFail) {
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
          inAsyncCall: state is PasswordResetConfirmLoading,
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
                        SizedBox(height: ScreenSize.height * 0.0890557 * 2.5),
                        CustomMainText(txt: 'Forgot Password?'),
                        SizedBox(height: ScreenSize.height * 0.016094 * 2),
                        Text(
                          'Don\'t worry! It occurs. Please enter the email address linked with your account.',
                          style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: ScreenSize.height * 0.017,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: ScreenSize.height * 0.016094 * 2),
                        CustomInputField(
                          fieldKey: emailKey,
                          hint: "Enter your email",
                          label: 'Email',
                          fieldController: textEditingController,
                          isPassword: false,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is required';
                            } else if (!value.contains('@')) {
                              return "Enter a valid email";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: ScreenSize.height * 0.046094),

                        CustomButton(
                          onTap: () {
                            if (emailKey.currentState!.validate()) {
                              BlocProvider.of<AuthenticationCubit>(
                                context,
                              ).confirmEmailToChangePassword(
                                email: textEditingController.text,
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
                                'Login',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
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
