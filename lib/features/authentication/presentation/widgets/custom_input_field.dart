import 'package:flutter/material.dart';
import 'package:nurse_servant/core/utils/color_guide.dart';
import 'package:nurse_servant/core/utils/screen_size.dart';

class CustomInputField extends StatelessWidget {
  CustomInputField({
    super.key,
    required this.fieldKey,
    required this.hint,
    required this.label,
    required this.fieldController,
    required this.isPassword,
    required this.textInputType,
    this.isObsecured = false,
    this.onTap,
    this.validator,
  });
  final GlobalKey<FormState> fieldKey;
  final String hint;
  final String label;
  final TextEditingController fieldController;
  final bool isPassword;
  final TextInputType textInputType;
  bool isObsecured;
  VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: fieldKey,
      child: TextFormField(
        controller: fieldController,
        validator: validator,
        obscureText: isObsecured,
        keyboardType: textInputType,
        decoration: InputDecoration(
          isDense: true,
          fillColor: Color(0xffF7F8F9),
          filled: true,
          hint: Text(hint),
          label: Text(label, style: TextStyle(color: ColorGuide.mainColor)),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onTap,
                  icon: !isObsecured
                      ? Icon(Icons.visibility_off_outlined)
                      : Icon(Icons.visibility_outlined),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ScreenSize.height * 0.015),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ScreenSize.height * 0.015),
            borderSide: BorderSide(color: ColorGuide.mainColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ScreenSize.height * 0.015),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ScreenSize.height * 0.015),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
