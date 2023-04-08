import 'package:flutter/material.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/dimens.dart';

class TextStyles {
  static const TextStyle textSize12 = TextStyle(
    fontSize: Dimens.font_sp12,
  );
  static const TextStyle textSize16 = TextStyle(
    fontSize: Dimens.font_sp16,
  );
  static const TextStyle textBold14 =
      TextStyle(fontSize: Dimens.font_sp14, fontWeight: FontWeight.bold);
  static const TextStyle textBold16 =
      TextStyle(fontSize: Dimens.font_sp16, fontWeight: FontWeight.bold);
  static const TextStyle textBold18 =
      TextStyle(fontSize: Dimens.font_sp18, fontWeight: FontWeight.bold);
  static const TextStyle textBold20 =
      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  static const TextStyle textBold24 =
      TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
  static const TextStyle textBold26 =
      TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold);

  static const TextStyle textGray12 = TextStyle(
      fontSize: Dimens.font_sp12,
      color: Colours.text_grey,
      fontWeight: FontWeight.normal);

  static const TextStyle textGray14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_grey,
  );
  static const TextStyle textGray16 = TextStyle(
    fontSize: Dimens.font_sp16,
    color: Colours.text_grey,
  );
  static const TextStyle textGray18 = TextStyle(
    fontSize: Dimens.font_sp18,
    color: Colours.text_grey,
  );
}
