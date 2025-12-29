import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model.dart';
import 'package:nurse_servant/features/home/presentation/cubit/load_from_hive_cubit.dart';
import 'package:nurse_servant/features/home/presentation/pages/home_view.dart';
import 'package:nurse_servant/features/home/presentation/widgets/custom_datails_row.dart';
import 'package:nurse_servant/features/home/presentation/widgets/custom_details_header.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails({super.key});
  static const String routeName = 'MedicineDetails';

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    MedicineModel medicineModel =
        ModalRoute.of(context)!.settings.arguments as MedicineModel;
    return BlocConsumer<LoadFromHiveCubit, LoadFromHiveState>(
      listener: (context, state) {
        if (state is RemovingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is RemovingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Medicine Removed',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: ColorGuide.mainColor,
            ),
          );
          BlocProvider.of<LoadFromHiveCubit>(context).getDataFromHive();
          Navigator.of(context).pushReplacementNamed(HomeView.routeName);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is RemovingLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.width * 0.05,
                    vertical: ScreenSize.height * 0.025,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenSize.width * 0.07,
                    vertical: ScreenSize.height * 0.2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      ScreenSize.height * 0.025,
                    ),
                    border: Border.all(color: Colors.grey),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 227, 244, 252),
                        Color.fromARGB(255, 247, 250, 252),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomDetailsHeader(
                        onTap: () {
                          showCupertinoDialog(
                            context: context,

                            builder: (context) => CupertinoAlertDialog(
                              actions: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: ScreenSize.height * .012,
                                  ),
                                  child: CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorGuide.mainColor,
                                        fontSize: ScreenSize.height * 0.025,
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: ScreenSize.height * .012,
                                  ),
                                  child: CupertinoDialogAction(
                                    onPressed: () {
                                      BlocProvider.of<LoadFromHiveCubit>(
                                        context,
                                      ).removeElement(medicineModel);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Yes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorGuide.mainColor,
                                        fontSize: ScreenSize.height * 0.025,
                                      ),
                                    ),
                                  ),
                                ),
                              ],

                              title: Text(
                                'Deleting a Medicine',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenSize.height * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              content: Text(
                                'Are you sure you want to delete this medicine?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: ScreenSize.height * 0.017,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: const Color.fromARGB(92, 158, 158, 158),
                        endIndent: ScreenSize.width * 0.12,
                        indent: ScreenSize.width * 0.12,
                      ),
                      Text(
                        'Did you take your Medicine?',
                        style: TextStyle(
                          color: ColorGuide.mainColor,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenSize.height * 0.025,
                        ),
                      ),
                      Image.asset(
                        'assets/caps7_9dsddssd 1.png',
                        width: ScreenSize.width * 0.28,
                        height: ScreenSize.height * 0.12,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        medicineModel.name,
                        style: TextStyle(
                          color: ColorGuide.mainColor,
                          fontSize: ScreenSize.height * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomDatailsRow(
                        txt:
                            '  Ends at ${DateFormat('hh:mm a, EEEE').format(medicineModel.endAt)}',
                        iconData: Icons.calendar_today_outlined,
                      ),
                      CustomDatailsRow(
                        txt:
                            '  ${medicineModel.amount} ${medicineModel.type}, ${medicineModel.dose}',
                        iconData: Icons.description_outlined,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: ScreenSize.height * 0.07,
                  left: ScreenSize.width * 0.05,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.maybePop(context);
                    },
                    child: Image.asset(
                      'assets/back.png',
                      width: ScreenSize.width * 0.15,
                      height: ScreenSize.height * .065,
                      fit: BoxFit.contain,
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
