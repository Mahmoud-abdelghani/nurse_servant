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
  bool pressed = false;
  String type = 'Select Option';
  bool picked = false;
  DateTime? selectedDateTime;
  bool alarmSet = false;
  DateTime? selectedTime;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoadFromHiveCubit, LoadFromHiveState>(
      listener: (context, state) {
        if (state is LoadToHiveLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Medicine Saved',
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
            backgroundColor: Colors.white,
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
                        CustomMainText(txt: 'Add New Medicine'),
                        SizedBox(height: ScreenSize.height * 0.02),
                        Text(
                          textAlign: TextAlign.center,
                          'Fill out the fields and hit the Save Button to add it!',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenSize.height * 0.021,
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomLabelText(txt: 'Name'),

                            CustomInputField(
                              fieldKey: nameKey,
                              hint: 'Enter medicin name',
                              label: 'Name',
                              fieldController: textEditingControllerName,
                              isPassword: false,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'fill that field';
                                } else {
                                  return null;
                                }
                              },
                            ),

                            CustomLabelText(txt: 'Type'),

                            GestureDetector(
                              onTap: () {
                                type == 'Select Option'
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
                                  color: Colors.white,
                                  elevation: 10,

                                  items: List.generate(
                                    types.length,
                                    (index) => PopupMenuItem(
                                      value: types[index],
                                      onTap: () {
                                        type = types[index];
                                        setState(() {});
                                      },
                                      height: ScreenSize.height * 0.055,
                                      child: Text(
                                        types[index],
                                        style: TextStyle(
                                          color: Colors.black,
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
                                    ? type != 'Select Option'
                                          ? ColorGuide.mainColor
                                          : Colors.black
                                    : ColorGuide.mainColor,
                                txt: type,
                                iconData: Icons.keyboard_arrow_down_outlined,
                              ),
                            ),
                            CustomLabelText(txt: 'Dose'),
                            CustomInputField(
                              fieldKey: doseKey,
                              hint: 'Enter medicin dose',
                              label: 'Dose',
                              fieldController: textEditingControllerdose,
                              isPassword: false,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'fill that field';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            CustomLabelText(txt: 'Amount'),
                            CustomInputField(
                              fieldKey: amountKey,
                              hint: 'Enter medicin amount',
                              label: 'Amount',
                              fieldController: textEditingControllerAmount,
                              isPassword: false,
                              textInputType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'fill that field';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: ScreenSize.height * 0.0185),
                            Text(
                              'Reminders',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenSize.height * 0.025,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenSize.height * 0.02,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: ScreenSize.height * 0.0085),
                            picked
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        ScreenSize.height * 0.025,
                                      ),
                                      border: Border.all(
                                        color: ColorGuide.mainColor,
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
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          DateFormat(
                                            'hh:mm',
                                          ).format(selectedDateTime!),
                                          style: TextStyle(
                                            fontSize: ScreenSize.height * 0.02,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          DateFormat(
                                            'a',
                                          ).format(selectedDateTime!),
                                          style: TextStyle(
                                            fontSize: ScreenSize.height * 0.02,
                                            color: Colors.black,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            showDatePicker(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber,
                                            minimumSize: Size(
                                              ScreenSize.width * 0.02,
                                              ScreenSize.height * 0.015,
                                            ),
                                          ),
                                          child: Text(
                                            'Edit',
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
                                      mainColor: Colors.grey,
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
                                color: const Color.fromARGB(133, 220, 220, 220),
                                borderRadius: BorderRadius.circular(
                                  ScreenSize.height * 0.015,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Turn on Alarm',
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
                              if (type != "Select Option" &&
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
                                      'hh:mm',
                                    ).format(selectedTime!),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Complete informations !',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          txt: 'Save',
                          active: true,
                          width: ScreenSize.width * 0.35,
                          height: ScreenSize.height * 0.05,
                        ),
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
          'Set Time for Alarm',
          style: TextStyle(
            color: ColorGuide.mainColor,
            fontSize: ScreenSize.height * 0.025,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
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
            txt: 'Cancel',
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
            txt: 'Save',
            active: true,
            width: ScreenSize.width * 0.055,
            height: ScreenSize.height * 0.055,
          ),
        ],
      ),
    );
  }
}
