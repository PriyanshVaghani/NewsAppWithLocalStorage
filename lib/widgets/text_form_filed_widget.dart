import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/utility/color_code.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.icon,
    required this.textEditingController,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.maxLength,
    this.isLengthSet = false,
  });

  final String hintText;
  final String labelText;
  final IconData icon;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool isLengthSet;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      cursorColor: ColorCode.colorPrimary,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Can't be Empty";
        } else if (isLengthSet && value.length != 10) {
          return "It must be 10 digit";
        }
        return null;
      },
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        icon: Icon(
          icon,
          color: ColorCode.colorPrimary,
        ),
        labelStyle: TextStyle(color: ColorCode.colorPrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorCode.colorGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorCode.colorPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorCode.colorRed, width: 2),
        ),
        counterText: "",
        isDense: true,
      ),
      maxLength: maxLength,
    );
  }
}
