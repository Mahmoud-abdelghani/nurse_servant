import 'dart:developer';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nurse_servant/core/services/hive_service.dart';
import 'package:nurse_servant/core/services/supabase_service.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:nurse_servant/features/authentication/presentation/pages/login_view.dart';
import 'package:nurse_servant/features/home/presentation/cubit/data_handling_cubit.dart';
import 'package:nurse_servant/features/home/presentation/cubit/load_from_hive_cubit.dart';
import 'package:nurse_servant/features/home/presentation/pages/add_med_view.dart';
import 'package:nurse_servant/features/home/presentation/pages/medicine_details.dart';
import 'package:nurse_servant/features/home/presentation/widgets/custom_image_button.dart';
import 'package:nurse_servant/features/home/presentation/widgets/custom_medicine_label.dart';
import 'package:nurse_servant/features/home/presentation/widgets/custom_next_amount.dart';
import 'package:nurse_servant/features/home/presentation/widgets/custom_no_medicine.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String routeName = 'HomeView';
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          HiveService.clearBox();
          Navigator.of(context).pushReplacementNamed(LoginView.routeName);
        } else if (state is LogoutFail) {
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
        return BlocConsumer<DataHandlingCubit, DataHandlingState>(
          listener: (context, state) {
            if (state is SyncUserSuccess) {
              BlocProvider.of<AuthenticationCubit>(context).logout();
            } else if (state is SyncUserError) {
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
              inAsyncCall: state is LogoutLoading || state is SyncUserLoading,
              child: BlocBuilder<LoadFromHiveCubit, LoadFromHiveState>(
                builder: (context, state) {
                  if (state is LoadFromHiveError) {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.width * 0.0579,
                        ),
                        child: Column(
                          children: [
                            Spacer(flex: 2),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    BlocProvider.of<AuthenticationCubit>(
                                      context,
                                    ).logout();
                                  },
                                  child: CustomImageButton(
                                    path: 'assets/Left Icon.png',
                                  ),
                                ),
                                Spacer(),
                                CustomImageButton(path: 'assets/6735312.jpg'),
                                CustomImageButton(
                                  path: 'assets/Right Icon.png',
                                ),
                              ],
                            ),
                            Divider(),
                            Spacer(flex: 1),
                            Text(state.message),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                    );
                  } else if (state is LoadFromHiveLoading) {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.width * 0.0579,
                        ),
                        child: Column(
                          children: [
                            Spacer(flex: 2),
                            Row(
                              children: [
                                CustomImageButton(path: 'assets/Left Icon.png'),
                                Spacer(),
                                CustomImageButton(path: 'assets/6735312.jpg'),
                                CustomImageButton(
                                  path: 'assets/Right Icon.png',
                                ),
                              ],
                            ),
                            Divider(),
                            Spacer(flex: 1),
                            Center(child: CircularProgressIndicator()),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                    );
                  } else if (state is LoadFromHiveSuccessButEmpty) {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.width * 0.0579,
                        ),
                        child: Column(
                          children: [
                            Spacer(flex: 2),
                            Row(
                              children: [
                                CustomImageButton(path: 'assets/Left Icon.png'),
                                Spacer(),
                                CustomImageButton(path: 'assets/6735312.jpg'),
                                CustomImageButton(
                                  path: 'assets/Right Icon.png',
                                ),
                              ],
                            ),
                            Divider(),
                            Spacer(flex: 1),
                            CustomNoMedicine(),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                    );
                  } else if (state is LoadFromHiveSuccess) {
                    return Scaffold(
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AddMedView.routeName);
                        },
                        backgroundColor: ColorGuide.mainColor,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                      backgroundColor: Colors.white,
                      body: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.width * 0.0579,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: ScreenSize.height * 0.055),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    BlocProvider.of<DataHandlingCubit>(
                                      context,
                                    ).syncAccount(state.mediciens);
                                  },
                                  child: CustomImageButton(
                                    path: 'assets/Left Icon.png',
                                  ),
                                ),
                                Spacer(),
                                CustomImageButton(path: 'assets/6735312.jpg'),
                                CustomImageButton(
                                  path: 'assets/Right Icon.png',
                                ),
                              ],
                            ),
                            Divider(),
                            EasyDateTimeLinePicker.itemBuilder(
                              timelineOptions: TimelineOptions(
                                height: ScreenSize.height * 0.09,
                              ),

                              firstDate: DateTime(DateTime.now().year - 1),
                              lastDate: DateTime(DateTime.now().year + 1),
                              focusedDate: DateTime.now(),
                              onDateChange: (date) {},
                              itemBuilder:
                                  (
                                    BuildContext context,
                                    DateTime date,
                                    bool isSelected,
                                    bool isDisabled,
                                    bool isToday,
                                    void Function() onTap,
                                  ) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        ScreenSize.height * .02,
                                      ),
                                      border: Border.all(
                                        width: isToday
                                            ? ScreenSize.height * 0.0019
                                            : ScreenSize.height * 0.0012,
                                        color: isSelected
                                            ? ColorGuide.mainColor
                                            : const Color.fromARGB(
                                                87,
                                                158,
                                                158,
                                                158,
                                              ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          date.day.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenSize.height * 0.023,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('EEE').format(date),
                                          style: TextStyle(
                                            color: isToday
                                                ? ColorGuide.mainColor
                                                : const Color.fromARGB(
                                                    158,
                                                    158,
                                                    158,
                                                    158,
                                                  ),
                                            fontWeight: FontWeight.w500,
                                            fontSize: ScreenSize.height * 0.02,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              itemExtent: ScreenSize.width * .15,
                            ),
                            SizedBox(height: ScreenSize.height * 0.01),

                            Text(
                              'Intakes',
                              style: TextStyle(
                                color: ColorGuide.mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenSize.height * 0.035,
                              ),
                            ),
                            SizedBox(height: ScreenSize.height * 0.01),
                            CustomNextAmount(
                              nextAmount: state.mediciens.first.amount
                                  .toString(),
                            ),

                            Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.only(
                                  top: ScreenSize.height * 0.05,
                                ),
                                clipBehavior: Clip.hardEdge,

                                itemCount: state.mediciens.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          MedicineDetails.routeName,
                                          arguments: state.mediciens[index],
                                        );
                                      },
                                      child: CustomMedicineLabel(
                                        title: state.mediciens[index].name,
                                        amount: state.mediciens[index].amount,
                                        type: state.mediciens[index].type,
                                        dose: state.mediciens[index].dose,
                                        alarmAt: state.mediciens[index].alarmAt,
                                      ),
                                    ),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: ScreenSize.height * 0.025),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.width * 0.0579,
                        ),
                        child: Column(
                          children: [
                            Spacer(flex: 2),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    BlocProvider.of<AuthenticationCubit>(
                                      context,
                                    ).logout();
                                  },
                                  child: CustomImageButton(
                                    path: 'assets/Left Icon.png',
                                  ),
                                ),
                                Spacer(),
                                CustomImageButton(path: 'assets/6735312.jpg'),
                                CustomImageButton(
                                  path: 'assets/Right Icon.png',
                                ),
                              ],
                            ),
                            Divider(),
                            Spacer(flex: 1),
                            CustomNoMedicine(),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
