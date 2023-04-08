import 'package:flutter/material.dart';

import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';

showBasicsFlash({
  required BuildContext context,
  required Duration duration,
  required String message,
  flashStyle = FlashBehavior.floating,
}) {
  showFlash(
    context: context,
    duration: duration,
    builder: (context, controller) {
      return Flash(
        controller: controller,
        behavior: flashStyle,
        position: FlashPosition.bottom,
        boxShadows: kElevationToShadow[4],
        horizontalDismissDirection: HorizontalDismissDirection.horizontal,
        child: FlashBar(
          content: Text(message),
        ),
      );
    },
  );
}

void showBottomFlash({
  required Widget title,
  Widget? content,
  required BuildContext context,
  bool persistent = true,
  EdgeInsets margin = EdgeInsets.zero,
}) {
  showFlash(
    context: context,
    persistent: persistent,
    builder: (_, controller) {
      return Flash(
        controller: controller,
        margin: margin,
        behavior: FlashBehavior.fixed,
        position: FlashPosition.bottom,
        borderRadius: BorderRadius.circular(8.0),
        borderColor: Colors.blue,
        boxShadows: kElevationToShadow[8],
        backgroundGradient: RadialGradient(
          colors: [Colors.amber, Colors.black87],
          center: Alignment.topLeft,
          radius: 2,
        ),
        onTap: () => controller.dismiss(),
        forwardAnimationCurve: Curves.easeInCirc,
        reverseAnimationCurve: Curves.bounceIn,
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: FlashBar(
            title: title,
            content: content!,
            indicatorColor: Colors.red,
            icon: Icon(Icons.info_outline),
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child: Text('DISMISS'),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => controller.dismiss(context),
                  child: Text('YES')),
              TextButton(
                  onPressed: () => controller.dismiss(context),
                  child: Text('NO')),
            ],
          ),
        ),
      );
    },
  ).then((_) {
    if (_ != null) {
      showMessage(context, _.toString());
    }
  });
}

void showInputFlash({
  required BuildContext context,
  bool persistent = true,
  required WillPopCallback onWillPop,
  required Color barrierColor,
}) {
  var editingController = TextEditingController();
  context.showFlashBar(
    persistent: persistent,
    onWillPop: onWillPop,
    barrierColor: barrierColor,
    borderWidth: 3,
    behavior: FlashBehavior.fixed,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: Text('Hello Flash'),
    content: Column(
      children: [
        Text('You can put any message of any length here.'),
        Form(
          child: TextFormField(
            controller: editingController,
            autofocus: true,
          ),
        ),
      ],
    ),
    indicatorColor: Colors.red,
    primaryActionBuilder: (context, controller, _) {
      return IconButton(
        onPressed: () {
          if (editingController.text.isEmpty) {
            controller.dismiss();
          } else {
            var message = editingController.text;
            showMessage(context, message);
            editingController.text = '';
          }
        },
        icon: Icon(Icons.send, color: Colors.amber),
      );
    },
  );
}

void showOKDialogFlash({
  required BuildContext context,
  bool persistent = true,
  Widget? title,
  Widget? content,
  required Function confirmFunction,
  required String confirmText,
}) {
  context.showFlashDialog(
      persistent: persistent,
      title: title ?? Text('de'),
      content: content ?? Text(''),
      positiveActionBuilder: (context, controller, _) {
        return TextButton(
            onPressed: () {
              confirmFunction();
              controller.dismiss();
            },
            child: Text(
              confirmText,
            ));
      });
}

void showConfirmDialogFlash({
  required BuildContext context,
  bool persistent = true,
  Widget? title,
  Widget? content,
  required Function confirmFunction,
  required String confirmText,
  required Function cancelFunction,
  required String cancelText,
}) {
  context.showFlashDialog(
      persistent: persistent,
      title: title ?? Text('de'),
      content: content ?? Text(''),
      negativeActionBuilder: (context, controller, _) {
        return TextButton(
          onPressed: () {
            cancelFunction();
            controller.dismiss();
          },
          child: Text(cancelText),
        );
      },
      positiveActionBuilder: (context, controller, _) {
        return TextButton(
            onPressed: () {
              confirmFunction();
              controller.dismiss();
            },
            child: Text(
              confirmText,
            ));
      });
}

void showMessage(@required BuildContext context, String message) {
  //if (!mounted) return;
  showFlash(
      context: context,
      duration: Duration(seconds: 3),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          position: FlashPosition.top,
          behavior: FlashBehavior.fixed,
          child: FlashBar(
            icon: Icon(
              Icons.face,
              size: 36.0,
              color: Colors.black,
            ),
            content: Text(message),
          ),
        );
      });
}
