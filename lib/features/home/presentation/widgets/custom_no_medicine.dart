import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show TextButton, Colors, MaterialButton;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:nurse_servant/features/home/presentation/cubit/data_handling_cubit.dart';
import 'package:nurse_servant/features/home/presentation/pages/add_med_view.dart';

class CustomNoMedicine extends StatelessWidget {
  const CustomNoMedicine({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/reminder_12570772.png'),
        SizedBox(height: ScreenSize.height * 0.035),
        Text(
          'Manage your meds',
          style: TextStyle(
            color: ColorGuide.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: ScreenSize.height * 0.035,
          ),
        ),

        Text(
          textAlign: TextAlign.center,
          'Add your meds to be reminded on time and track your health ',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: ScreenSize.height * 0.02,
          ),
        ),
        SizedBox(height: ScreenSize.height * 0.035 * 3),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddMedView.routeName);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(
              ScreenSize.height * 0.015,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.width * 0.055,
            vertical: ScreenSize.height * 0.01,
          ),
          color: Colors.amber,
          child: Text(
            'Add medicine',
            style: TextStyle(
              fontSize: ScreenSize.height * 0.035,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: ScreenSize.height * 0.035 * 2),
        TextButton(
          onPressed: () {
            BlocProvider.of<DataHandlingCubit>(context).syncAccount([]);
            BlocProvider.of<AuthenticationCubit>(context).logout();
          },
          child: Text(
            'Sign out',
            style: TextStyle(
              color: Colors.red,
              fontSize: ScreenSize.height * 0.025,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
