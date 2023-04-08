import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurent_user/res/colors.dart';

class ThemeProvider extends ChangeNotifier {
  static ThemeData getTheme() {
    return ThemeData(
      scrollbarTheme:
          ScrollbarThemeData(showTrackOnHover: true, isAlwaysShown: true),
      errorColor: Colours.red,
      brightness: Brightness.light,
      primaryColor: Colours.app_main,
      scaffoldBackgroundColor: Colours.bg_color,
      cardColor: Colours.card_color,
      // visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(elevation: 0, color: Colours.bg_color),
      cardTheme: CardTheme(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colours.card_color,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colours.app_main,
        foregroundColor: Colours.accent,
      ),
      primaryIconTheme: IconThemeData(
        color: Colours.accent,
      ),
    );
  }
}
