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
                Localizations.localeOf(context).languageCode == 'ar'
                    ? 'إزالة الدواء'
                    : 'Medicine Removed',
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
                    gradient: SweepGradient(
                      colors: [
                        Theme.of(context).cardColor,
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                    // LinearGradient(
                    // colors: [
                    //   Theme.of(context).cardColor,
                    //   Theme.of(context).scaffoldBackgroundColor,
                    // ],
                    // ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomDetailsHeader(
                        onTap: () {
                          showCupertinoDialog(
                            context: context,

                            builder: (context) => CupertinoTheme(
                              data: CupertinoThemeData(
                                brightness: Theme.of(context).brightness,
                              ),
                              child: CupertinoAlertDialog(
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
                                        Localizations.localeOf(
                                                  context,
                                                ).languageCode ==
                                                'ar'
                                            ? 'لا'
                                            : 'No',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
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
                                        Localizations.localeOf(
                                                  context,
                                                ).languageCode ==
                                                'ar'
                                            ? 'نعم'
                                            : 'Yes',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: ScreenSize.height * 0.025,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                                title: Text(
                                  Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? 'حذف دواء'
                                      : 'Deleting a Medicine',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: ScreenSize.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                content: Text(
                                  Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? 'هل أنت متأكد من رغبتك في حذف هذا الدواء؟'
                                      : 'Are you sure you want to delete this medicine?',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenSize.height * 0.017,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: Theme.of(context).dividerColor,
                        endIndent: ScreenSize.width * 0.12,
                        indent: ScreenSize.width * 0.12,
                      ),
                      Text(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 'هل تناولت دوائك؟'
                            : 'Did you take your Medicine?',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenSize.height * 0.023,
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
                          color: Theme.of(context).primaryColor,
                          fontSize: ScreenSize.height * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomDatailsRow(
                        txt:
                            Localizations.localeOf(context).languageCode == 'ar'
                            ? '  ينتهى فى ${DateFormat('hh:mm a, EEEE').format(medicineModel.endAt)}'
                            : '  Ends at ${DateFormat('hh:mm a, EEEE').format(medicineModel.endAt)}',
                        iconData: Icons.calendar_today_outlined,
                      ),
                      CustomDatailsRow(
                        txt:
                            '  ${medicineModel.amount} ${medicineModel.type}, ${medicineModel.dose}',
                        iconData: Icons.description_outlined,
                      ),
                      CustomDatailsRow(
                        txt:
                            Localizations.localeOf(context).languageCode == 'ar'
                            ? '   الحرعة القادمه الساعة ${medicineModel.nextDose}'
                            : '   Next dose at ${medicineModel.nextDose}',
                        iconData: Icons.watch_later_outlined,
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
