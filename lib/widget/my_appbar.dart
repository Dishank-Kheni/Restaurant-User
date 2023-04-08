import 'package:flutter/material.dart';
import 'package:restaurent_user/res/colors.dart';

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  MyAppBar(
      {this.actions,
      this.bgColor,
      this.elevation,
      this.iconThemeData,
      this.leading,
      this.title});
  IconThemeData? iconThemeData = IconThemeData(color: Colors.amberAccent);
  Widget? title;
  Color? bgColor = Colours.bg_color;
  Widget? leading;
  List<Widget>? actions;
  double? elevation = 0;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: iconThemeData,
      elevation: elevation,
      title: title ?? null,
      leading: leading ?? null,
      backgroundColor: bgColor,
      actions: actions ?? null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
