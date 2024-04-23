import 'package:flutter/material.dart';
import 'package:news_app/utility/color_code.dart';

ThemeData theme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: ColorCode.colorPrimary,
    iconTheme: IconThemeData(color: ColorCode.colorWhite), titleTextStyle: TextStyle(
    color: ColorCode.colorWhite,
    fontSize: 20,
  ),
  ),
  textTheme: TextTheme(
    // This for splash screen app name text
    displayLarge: TextStyle(color: ColorCode.colorWhite, fontSize: 24),

    // This for elevated button text
    titleSmall: TextStyle(color: ColorCode.colorWhite, fontSize: 20),
    // This for text button text
    titleMedium: TextStyle(color: ColorCode.colorPrimary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorCode.colorPrimary,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: TextStyle(color: ColorCode.colorPrimary),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.selected)) {
          return ColorCode.colorPrimary;
        }
        return ColorCode.colorWhite;
      },
    ),
  ),
);

Widget buildCircularProgressIndicator() {
  return CircularProgressIndicator(color: ColorCode.colorPrimary);
}
