import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nurse_servant/core/services/supabase_service.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/login_view.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_button.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_main_text.dart';
import 'package:nurse_servant/features/home/presentation/cubit/data_handling_cubit.dart';
import 'package:nurse_servant/features/home/presentation/cubit/load_from_hive_cubit.dart';
import 'package:nurse_servant/features/home/presentation/pages/home_view.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});
  static const String routeName = 'OtpView';

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
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
          Navigator.pushReplacementNamed(context, HomeView.routeName);
        }
      },
      builder: (context, state) {
        return BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
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
              inAsyncCall: state is LoginLoading,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Spacer(flex: 4),
                          CustomMainText(txt: 'Verification'),
                          Spacer(flex: 1),
                          Text(
                            'We have sent you an email verification',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenSize.height * 0.017,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Spacer(flex: 4),

                          CustomButton(
                            onTap: () {
                              BlocProvider.of<AuthenticationCubit>(
                                context,
                              ).login(
                                email: context
                                    .read<AuthenticationCubit>()
                                    .gEmail,
                                password: context
                                    .read<AuthenticationCubit>()
                                    .gPassword,
                              );
                            },
                            txt: "Verify",
                            active: true,
                            width: ScreenSize.width,
                            height: ScreenSize.height * 0.068,
                          ),

                          Spacer(flex: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Didn’t received code?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenSize.height * 0.015,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Resend',
                                  style: TextStyle(
                                    color: ColorGuide.mainColor,
                                    fontSize: ScreenSize.height * 0.015,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(flex: 1),
                        ],
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
