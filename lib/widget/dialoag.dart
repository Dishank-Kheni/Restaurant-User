import 'package:flutter/material.dart';

class Dialoag {
  static Future errorDialoag({
    required BuildContext context,
    Widget? title,
    Widget? subContent,
  }) {
    return showDialog(
      context: context,
      builder: (content) => AlertDialog(
        title: title ?? Text(''),
        content: subContent ?? Text(''),
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ok'),
          ),
        ],
      ),
    );
  }
}
