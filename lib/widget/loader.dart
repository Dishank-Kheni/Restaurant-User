import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restaurent_user/res/colors.dart';

const loader = Center(
  child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
      backgroundColor: Colours.accent),
);

const threeBounceSpinkit = SpinKitThreeBounce(
  color: Colours.accent,
  size: 30,
);

const threBounceSpinKitWithWhite = SpinKitThreeBounce(
  color: Colors.white,
  size: 30,
);
