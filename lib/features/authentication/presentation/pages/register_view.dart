import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nurse_servant/core/services/supabase_service.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/login_view.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/otp_view.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_button.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_divider.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_google_button.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_input_field.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_main_text.dart';
import 'package:nurse_servant/features/home/presentation/cubit/data_handling_cubit.dart';
import 'package:nurse_servant/features/home/presentation/cubit/load_from_hive_cubit.dart';
import 'package:nurse_servant/features/home/presentation/pages/home_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static const String routeName = "RegisterView";
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordConfirmationKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController eamilController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
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
          Navigator.pushNamed(context, HomeView.routeName);
        }
      },
      builder: (context, state) {
        return BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationGoogleSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "nursing app at your sevice",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: ColorGuide.mainColor,
                ),
              );
              BlocProvider.of<DataHandlingCubit>(context).creatNewUserOrFetch(
                SupabaseService.supabase.auth.currentUser!.email!,
              );
              BlocProvider.of<LoadFromHiveCubit>(context).getDataFromHive();
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
            } else if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "nursing app at your sevice",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: ColorGuide.mainColor,
                ),
              );
              Navigator.of(context).pushReplacementNamed(OtpView.routeName);
            } else if (state is RegisterFail) {
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
                  state is RegisterLoading,
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
                            SizedBox(
                              height: ScreenSize.height * 0.0890557 * 1.5,
                            ),
                            CustomMainText(
                              txt: 'Hello! Register to get started',
                            ),
                            SizedBox(height: ScreenSize.height * 0.016094 * 2),
                            CustomInputField(
                              fieldKey: nameKey,
                              hint: "Enter your name",
                              label: 'User name',
                              fieldController: nameController,
                              isPassword: false,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: ScreenSize.height * 0.016094),
                            CustomInputField(
                              fieldKey: emailKey,
                              hint: "Enter your email",
                              label: 'Email',
                              fieldController: eamilController,
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
                            SizedBox(height: ScreenSize.height * 0.016094),

                            CustomInputField(
                              fieldKey: passwordKey,
                              hint: "Enter your password",
                              label: 'password',
                              fieldController: passwordController,
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
                                  return 'This field is required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: ScreenSize.height * 0.016094),
                            CustomInputField(
                              fieldKey: passwordConfirmationKey,
                              hint: "Confirm your password",
                              label: 'Confirmation',
                              fieldController: confirmController,
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
                                  return 'This field is required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: ScreenSize.height * 0.016094),

                            CustomButton(
                              onTap: () {
                                if (emailKey.currentState!.validate() ||
                                    nameKey.currentState!.validate() ||
                                    passwordKey.currentState!.validate() ||
                                    passwordConfirmationKey.currentState!
                                        .validate()) {}
                                if (emailKey.currentState!.validate() &&
                                    nameKey.currentState!.validate() &&
                                    passwordKey.currentState!.validate() &&
                                    passwordConfirmationKey.currentState!
                                        .validate()) {
                                  BlocProvider.of<AuthenticationCubit>(
                                    context,
                                  ).register(
                                    email: eamilController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                  );
                                }
                              },
                              txt: "Register",
                              active: true,
                              width: ScreenSize.width,
                              height: ScreenSize.height * 0.068,
                            ),
                            SizedBox(
                              height: ScreenSize.height * 0.016094 * 1.2,
                            ),
                            CustomDivider(),
                            SizedBox(
                              height: ScreenSize.height * 0.016094 * 1.2,
                            ),
                            CustomGoogleButton(
                              ontap: () {
                                BlocProvider.of<AuthenticationCubit>(
                                  context,
                                ).signInWithGoogle();
                              },
                            ),
                            SizedBox(height: ScreenSize.height * 0.0490557),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenSize.height * 0.015,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(LoginView.routeName);
                                  },
                                  child: Text(
                                    'Log in',
                                    style: TextStyle(
                                      color: ColorGuide.mainColor,
                                      fontSize: ScreenSize.height * 0.015,
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
