import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_button.dart';
import 'package:nurse_servant/features/authentication/presentation/widgets/custom_input_field.dart';

import 'package:nurse_servant/features/authentication/presentation/widgets/custom_main_text.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model.dart';
import 'package:nurse_servant/features/home/presentation/cubit/load_from_hive_cubit.dart';
import 'package:nurse_servant/features/home/presentation/widgets/custom_date_time.dart';
import 'package:nurse_servant/features/home/presentation/widgets/custom_label_text.dart';
import 'package:nurse_servant/features/home/presentation/widgets/custom_selection_container.dart';

class AddMedView extends StatefulWidget {
  const AddMedView({super.key});
  static const String routeName = 'AddMedView';

  @override
  State<AddMedView> createState() => _AddMedViewState();
}

class _AddMedViewState extends State<AddMedView> {
  GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  GlobalKey<FormState> doseKey = GlobalKey<FormState>();
  GlobalKey<FormState> amountKey = GlobalKey<FormState>();

  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerdose = TextEditingController();
  TextEditingController textEditingControllerAmount = TextEditingController();
  List<String> types = ['Capsule', 'Drop', 'Tablet'];
  List<String> typesAr = ['كبسولة', 'نقط', 'قرص'];
  bool pressed = false;
  String type = 'Select Option';
  String typeAr = 'أختار النوع';
  bool picked = false;
  DateTime? selectedDateTime;
  bool alarmSet = false;
  DateTime? selectedTime;
  DateTime? repeatedEvery;
  bool rebeat = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoadFromHiveCubit, LoadFromHiveState>(
      listener: (context, state) {
        if (state is LoadToHiveLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Localizations.localeOf(context).languageCode == 'ar'
                    ? 'تم تخزين الدواء بنجاح'
                    : 'Medicine Stored successfully',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: ColorGuide.mainColor,
            ),
          );
          BlocProvider.of<LoadFromHiveCubit>(context).getDataFromHive();
          Navigator.maybePop(context);
        } else if (state is LoadToHiveError) {
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
          inAsyncCall: state is LoadToHiveLoading,
          child: Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.width * 0.0879,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: ScreenSize.height * 0.08),
                        CustomMainText(
                          txt:
                              Localizations.localeOf(context).languageCode ==
                                  'ar'
                              ? 'أضف دواء جديد'
                              : 'Add New Medicine',
                        ),
                        SizedBox(height: ScreenSize.height * 0.02),
                        Text(
                          textAlign: TextAlign.center,
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'املأ الحقول واضغط على زر الحفظ لإضافته!'
                              : 'Fill out the fields and hit the Save Button to add it!',
                          style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenSize.height * 0.021,
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomLabelText(
                              txt:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'الأسم'
                                  : 'Name',
                            ),

                            CustomInputField(
                              fieldKey: nameKey,
                              hint:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'أدخل اسم الدواء'
                                  : 'Enter medicin name',
                              label:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'الأسم'
                                  : 'Name',
                              fieldController: textEditingControllerName,
                              isPassword: false,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? 'املأ هذا الحقل'
                                      : 'fill that field';
                                } else {
                                  return null;
                                }
                              },
                            ),

                            CustomLabelText(
                              txt:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'النوع'
                                  : 'Type',
                            ),

                            GestureDetector(
                              onTap: () {
                                (Localizations.localeOf(context).languageCode ==
                                                'ar'
                                            ? typeAr
                                            : type) ==
                                        (Localizations.localeOf(
                                                  context,
                                                ).languageCode ==
                                                'ar'
                                            ? 'أختار النوع'
                                            : 'Select Option')
                                    ? pressed = !pressed
                                    : pressed = pressed;
                                setState(() {});
                                showMenu(
                                  menuPadding: EdgeInsets.symmetric(
                                    horizontal: ScreenSize.width * 0.0879,
                                  ),
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                    ScreenSize.width * 0.0879,
                                    ScreenSize.height * 0.425,
                                    ScreenSize.width * 0.0879,
                                    0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      ScreenSize.height * 0.02,
                                    ),
                                  ),
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  elevation: 10,

                                  items: List.generate(
                                    types.length,
                                    (index) => PopupMenuItem(
                                      value:
                                          Localizations.localeOf(
                                                context,
                                              ).languageCode ==
                                              'ar'
                                          ? typesAr[index]
                                          : types[index],
                                      onTap: () {
                                        Localizations.localeOf(
                                                  context,
                                                ).languageCode ==
                                                'ar'
                                            ? typeAr = typesAr[index]
                                            : type = types[index];
                                        setState(() {
                                          log(typeAr);
                                        });
                                      },
                                      height: ScreenSize.height * 0.055,
                                      child: Text(
                                        Localizations.localeOf(
                                                  context,
                                                ).languageCode ==
                                                'ar'
                                            ? typesAr[index]
                                            : types[index],
                                        style: TextStyle(
                                          color: Theme.of(context).hintColor,
                                          fontSize: ScreenSize.height * 0.025,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ).then((value) {
                                  value == null
                                      ? pressed = false
                                      : pressed = true;
                                  setState(() {});
                                });
                              },
                              child: CustomSelectionContainer(
                                mainColor: !pressed
                                    ? (Localizations.localeOf(
                                                        context,
                                                      ).languageCode ==
                                                      'ar'
                                                  ? typeAr
                                                  : type) !=
                                              (Localizations.localeOf(
                                                        context,
                                                      ).languageCode ==
                                                      'ar'
                                                  ? 'أختار النوع'
                                                  : 'Select Option')
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).hintColor
                                    : Theme.of(context).primaryColor,
                                txt:
                                    Localizations.localeOf(
                                          context,
                                        ).languageCode ==
                                        'ar'
                                    ? typeAr
                                    : type,
                                iconData: Icons.keyboard_arrow_down_outlined,
                              ),
                            ),
                            CustomLabelText(
                              txt:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'الجرعة'
                                  : 'Dose',
                            ),
                            CustomInputField(
                              fieldKey: doseKey,

                              hint:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'أدخل جرعة الدواء'
                                  : 'Enter medicin dose',
                              label:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'الجرعة'
                                  : 'Dose',
                              fieldController: textEditingControllerdose,
                              isPassword: false,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? 'املأ هذا الحقل'
                                      : 'fill that field';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            CustomLabelText(
                              txt:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'الكمية'
                                  : 'Amount',
                            ),
                            CustomInputField(
                              fieldKey: amountKey,
                              hint:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'أدخل كمية الدواء'
                                  : 'Enter medicin amount',
                              label:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'الكمية'
                                  : 'Amount',
                              fieldController: textEditingControllerAmount,
                              isPassword: false,
                              textInputType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'ar'
                                      ? 'املأ هذا الحقل'
                                      : 'fill that field';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: ScreenSize.height * 0.0185),
                            Text(
                              Localizations.localeOf(context).languageCode ==
                                      'ar'
                                  ? 'تذكيرات'
                                  : 'Reminders',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: ScreenSize.height * 0.025,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              Localizations.localeOf(context).languageCode ==
                                      'ar'
                                  ? 'التاريخ'
                                  : 'Date',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: ScreenSize.height * 0.02,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: ScreenSize.height * 0.0085),
                            picked
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).secondaryHeaderColor,
                                      borderRadius: BorderRadius.circular(
                                        ScreenSize.height * 0.025,
                                      ),
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          DateFormat(
                                            'EEE',
                                          ).format(selectedDateTime!),
                                          style: TextStyle(
                                            fontSize: ScreenSize.height * 0.02,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        Text(
                                          DateFormat(
                                            'hh:mm',
                                          ).format(selectedDateTime!),
                                          style: TextStyle(
                                            fontSize: ScreenSize.height * 0.02,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        Text(
                                          DateFormat(
                                            'a',
                                          ).format(selectedDateTime!),
                                          style: TextStyle(
                                            fontSize: ScreenSize.height * 0.02,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            showDatePicker(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(
                                              context,
                                            ).primaryColorDark,
                                            minimumSize: Size(
                                              ScreenSize.width * 0.02,
                                              ScreenSize.height * 0.015,
                                            ),
                                          ),
                                          child: Text(
                                            Localizations.localeOf(
                                                      context,
                                                    ).languageCode ==
                                                    'ar'
                                                ? 'تعديل'
                                                : 'Edit',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  ScreenSize.height * 0.022,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      showDatePicker(context);
                                      selectedDateTime = DateTime.now();
                                      picked = true;
                                      setState(() {});
                                    },
                                    child: CustomSelectionContainer(
                                      mainColor: Theme.of(context).dividerColor,
                                      txt: 'dd/mm/yyy , 00:00',
                                      iconData: Icons.calendar_month,
                                    ),
                                  ),
                            SizedBox(height: ScreenSize.height * 0.0185),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenSize.height * 0.01,
                                horizontal: ScreenSize.width * 0.05,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(
                                  ScreenSize.height * 0.015,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Localizations.localeOf(
                                              context,
                                            ).languageCode ==
                                            'ar'
                                        ? 'وقت الجرعة الأولى في اليوم'
                                        : 'Time of first dose in day',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenSize.height * 0.02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Switch(
                                    value: alarmSet,
                                    onChanged: (value) {
                                      showTimeSelector(context);
                                    },

                                    thumbColor: WidgetStatePropertyAll(
                                      Colors.white,
                                    ),
                                    trackOutlineColor: WidgetStatePropertyAll(
                                      Color.fromARGB(133, 220, 220, 220),
                                    ),
                                    trackColor: WidgetStatePropertyAll(
                                      alarmSet
                                          ? Colors.green
                                          : Color.fromARGB(133, 159, 158, 158),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenSize.height * 0.0185),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenSize.height * 0.01,
                                horizontal: ScreenSize.width * 0.05,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(
                                  ScreenSize.height * 0.015,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Localizations.localeOf(
                                              context,
                                            ).languageCode ==
                                            'ar'
                                        ? 'فترة التكرار'
                                        : 'Repetition period',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenSize.height * 0.02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Switch(
                                    value: rebeat,
                                    onChanged: (value) {
                                      showTimeRebeatedSelector(context);
                                    },

                                    thumbColor: WidgetStatePropertyAll(
                                      Colors.white,
                                    ),
                                    trackOutlineColor: WidgetStatePropertyAll(
                                      Color.fromARGB(133, 220, 220, 220),
                                    ),
                                    trackColor: WidgetStatePropertyAll(
                                      rebeat
                                          ? Colors.green
                                          : Color.fromARGB(133, 159, 158, 158),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenSize.height * 0.0185),
                        CustomButton(
                          onTap: () {
                            if (nameKey.currentState!.validate() ||
                                doseKey.currentState!.validate() ||
                                amountKey.currentState!.validate()) {}
                            if (nameKey.currentState!.validate() &&
                                doseKey.currentState!.validate() &&
                                amountKey.currentState!.validate()) {
                              if (Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? typeAr != 'أختار النوع'
                                  : type != "Select Option" &&
                                        selectedDateTime != null &&
                                        selectedTime != null) {
                                BlocProvider.of<LoadFromHiveCubit>(
                                  context,
                                ).storeInHive(
                                  MedicineModel(
                                    name: textEditingControllerName.text,
                                    type: type,
                                    dose: textEditingControllerdose.text,
                                    amount: int.parse(
                                      textEditingControllerAmount.text,
                                    ),
                                    endAt: selectedDateTime!,
                                    alarmAt: DateFormat(
                                      'HH:mm',
                                    ).format(selectedTime!),
                                    rebeatEvery: DateFormat(
                                      'HH:mm',
                                    ).format(repeatedEvery!),
                                    nextDose: DateFormat(
                                      'HH:mm',
                                    ).format(selectedTime!),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      Localizations.localeOf(
                                                context,
                                              ).languageCode ==
                                              'ar'
                                          ? 'أكمل المعلومات'
                                          : 'Complete informations !',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          txt:
                              Localizations.localeOf(context).languageCode ==
                                  'ar'
                              ? 'حفظ'
                              : 'Save',
                          active: true,
                          width: ScreenSize.width * 0.35,
                          height: ScreenSize.height * 0.05,
                        ),
                        SizedBox(height: ScreenSize.height * 0.0485),
                      ],
                    ),
                  ),
                ),
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
              ],
            ),
          ),
        );
      },
    );
  }

  void showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Center(
        child: SizedBox(
          height: ScreenSize.height * 0.35,
          child: CustomDateTime(
            onDateChange: (value) {
              selectedDateTime = value;
              picked = true;
              setState(() {});
            },
            cupertinoDatePickerMode: CupertinoDatePickerMode.dateAndTime,
          ),
        ),
      ),
    );
  }

  void showTimeSelector(BuildContext context) {
    selectedTime = DateTime.now();
    showCupertinoModalPopup(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceAround,
        title: Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'وقت الجرعة الأولى في اليوم'
              : 'Time of first dose in day',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: ScreenSize.height * 0.025,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: SizedBox(
          height: ScreenSize.height * 0.3,
          width: ScreenSize.width * 0.75,
          child: CustomDateTime(
            onDateChange: (value) {
              selectedTime = value;
            },
            cupertinoDatePickerMode: CupertinoDatePickerMode.time,
          ),
        ),
        actions: [
          CustomButton(
            onTap: () {
              Navigator.of(context).maybePop();
            },
            txt: Localizations.localeOf(context).languageCode == 'ar'
                ? 'الغاء'
                : 'Cancel',
            active: false,
            width: ScreenSize.width * 0.055,
            height: ScreenSize.height * 0.055,
          ),
          CustomButton(
            onTap: () {
              log(selectedTime.toString());
              alarmSet = true;
              Navigator.of(context).maybePop();
              setState(() {});
            },
            txt: Localizations.localeOf(context).languageCode == 'ar'
                ? 'حفظ'
                : 'Save',
            active: true,
            width: ScreenSize.width * 0.055,
            height: ScreenSize.height * 0.055,
          ),
        ],
      ),
    );
  }

  void showTimeRebeatedSelector(BuildContext context) {
    repeatedEvery = DateTime(DateTime.now().year);
    showCupertinoModalPopup(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceAround,
        title: Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'تحديد فترة التكرار'
              : 'Set Rebeation Period',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: ScreenSize.height * 0.025,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: SizedBox(
          height: ScreenSize.height * 0.3,
          width: ScreenSize.width * 0.75,
          child: CustomDateTime(
            onDateChange: (value) {
              repeatedEvery = value;
            },
            cupertinoDatePickerMode: CupertinoDatePickerMode.time,
          ),
        ),
        actions: [
          CustomButton(
            onTap: () {
              Navigator.of(context).maybePop();
            },
            txt: Localizations.localeOf(context).languageCode == 'ar'
                ? 'الغاء'
                : 'Cancel',
            active: false,
            width: ScreenSize.width * 0.055,
            height: ScreenSize.height * 0.055,
          ),
          CustomButton(
            onTap: () {
              log(repeatedEvery.toString());
              rebeat = true;
              Navigator.of(context).maybePop();
              setState(() {});
            },
            txt: Localizations.localeOf(context).languageCode == 'ar'
                ? 'حفظ'
                : 'Save',
            active: true,
            width: ScreenSize.width * 0.055,
            height: ScreenSize.height * 0.055,
          ),
        ],
      ),
    );
  }
}
