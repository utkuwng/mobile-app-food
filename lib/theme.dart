import 'package:flutter/material.dart';
import 'constants.dart';

const Color instagramPink = Color(0xFFE1306C);
const Color instagramGradientStart = Color(0xFFF58529);
const Color instagramGradientEnd = Color(0xFFDD2A7B);

ThemeData buildThemeData() {
  return ThemeData(
    primaryColor: instagramPink,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "SF Pro Text",
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    inputDecorationTheme: inputDecorationTheme,
    buttonTheme: buttonThemeData,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: instagramPink,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  fillColor: inputColor,
  filled: true,
  contentPadding: const EdgeInsets.all(defaultPadding),
  border: kDefaultOutlineInputBorder,
  enabledBorder: kDefaultOutlineInputBorder,
  focusedBorder: kDefaultOutlineInputBorder.copyWith(
    borderSide: BorderSide(color: instagramPink.withOpacity(0.7)),
  ),
  errorBorder: kDefaultOutlineInputBorder.copyWith(
    borderSide: kErrorBorderSide,
  ),
  focusedErrorBorder: kDefaultOutlineInputBorder.copyWith(
    borderSide: kErrorBorderSide,
  ),
);

const ButtonThemeData buttonThemeData = ButtonThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
);
