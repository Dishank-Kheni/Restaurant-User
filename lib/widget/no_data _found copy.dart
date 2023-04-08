import 'package:flutter/cupertino.dart';
import 'package:restaurent_user/util/screen_utill.dart';

class DataNotFound {
  static Widget dataNotFoundImg(context) => Container(
        height: Screen.height(context) * 0.7,
        width: Screen.width(context),
        //  margin: EdgeInsets.all(10),
        // padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/data_no_found.png'),
              fit: BoxFit.contain),
        ),
      );
}
