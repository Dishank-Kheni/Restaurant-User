import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:restaurent_user/common/common.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/util/screen_utill.dart';
import 'package:restaurent_user/widget/flash.dart';
import 'package:restaurent_user/widget/loader.dart';
import 'package:lottie/lottie.dart';

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  var cloudfirestore = FirebaseFirestore.instance;
  var firebaseauth = FirebaseAuth.instance;

  var isloading = false;
  var gloabeKey = GlobalKey<FormState>();
  var tableno;
  var tableId;

  Future<void> scanQRCode(user) async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        "#e6e6e6",
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      final _qrData = await cloudfirestore
          .collection('qr')
          .where('qrId', isEqualTo: qrCode)
          .get();
      if (_qrData.docs.length <= 0) {
        showOKDialogFlash(
            context: context,
            confirmFunction: () {},
            confirmText: 'ok',
            title: Text(
              'Not a valid QR!',
              style: TextStyles.textBold16.copyWith(color: Colours.red),
            ),
            content: Text(Constants.qrscan_error));
        return;
      } else {
        print(_qrData.docs[0]['tableId']);
        await cloudfirestore.collection('request').add({
          'userId': user['userId'],
          'userName': user['userName'],
          'userEmail': user['userEmail'],
          'tableId': _qrData.docs[0]['tableId'],
          'tableNo': _qrData.docs[0]['tableNo'],
          'isRequestAccept': false,
        }).then((val) async {
          await cloudfirestore
              .collection('request')
              .doc(val.id)
              .update({'requestId': val.id});
        });
        await cloudfirestore
            .collection('user')
            .doc(firebaseauth.currentUser!.uid)
            .update({'isRequestSent': true});

        showBasicsFlash(
            context: context,
            duration: Duration(seconds: 2),
            message: Constants.request_sent);
      }
    } catch (e) {
      showOKDialogFlash(
          context: context,
          confirmFunction: () {},
          confirmText: 'ok',
          title: Text(
            Constants.qrscan_error1,
            style: TextStyles.textBold16.copyWith(color: Colours.red),
          ),
          content: Text(e.toString()));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colours.bg_color,
      body: FutureBuilder(
        future: cloudfirestore
            .collection('user')
            .doc(firebaseauth.currentUser!.uid)
            .get(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData ||
              userSnapshot.connectionState == ConnectionState.waiting ||
              userSnapshot.hasError)
            return threeBounceSpinkit;
          else
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 120,
                    width: 240,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            color: Colours.accent,
                            fontSize: 22,
                            wordSpacing: 4,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold),
                        child: AnimatedTextKit(animatedTexts: [
                          TypewriterAnimatedText(
                              'Welcome We are open Lpsrum Restaurent...',
                              speed: Duration(milliseconds: 400)),
                        ]),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Lottie.asset(
                  'assets/menu_scan.json',
                  alignment: Alignment.bottomCenter,
                  height: Screen.height(context) * 0.5,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Spacer(),
                Stack(
                  children: [
                    Container(
                      height: Screen.height(context) * 0.1,
                      decoration: BoxDecoration(
                        color: Colours.accent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -30,
                      left: Screen.width(context) * 0.5 -
                          Screen.height(context) * 0.05,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print(userSnapshot.data['userName']);
                              scanQRCode(userSnapshot.data);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colours.accent,
                              radius: Screen.height(context) * 0.045,
                              child: CircleAvatar(
                                backgroundColor: Colours.bg_color,
                                radius: Screen.height(context) * 0.05,
                                backgroundImage: AssetImage(
                                  'assets/qr_code.png',
                                ),
                                foregroundImage: AssetImage(
                                  'assets/qr_code.png',
                                ),
                                //  backgroundImage: AssetImage('asset/'),
                                // backgroundColor: Colors.orange,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'SCAN THE QR',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  ],
                  // ignore: deprecated_member_use
                  overflow: Overflow.visible,
                )
              ],
            );
        },
      ),
    );
  }
}
