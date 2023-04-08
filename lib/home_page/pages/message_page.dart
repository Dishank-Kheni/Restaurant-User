import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurent_user/common/common.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/gaps.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/util/screen_utill.dart';
import 'package:restaurent_user/widget/flash.dart';
import 'package:restaurent_user/widget/loader.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool _isLoading = false;
  late Timer time1;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            width: 240,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: DefaultTextStyle(
                style: TextStyle(
                    color: Colours.accent,
                    fontSize: 26,
                    wordSpacing: 4,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
                child: AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText('Request sent successfully.....',
                      speed: Duration(milliseconds: 400)),
                ]),
              ),
            ),
          ),
          Lottie.asset(
            'assets/req_sent_2.json',
            height: Screen.height(context) * 0.5,
            width: double.infinity,
            alignment: Alignment.center,
            //fit: BoxFit.contain
          ),
          Spacer(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        final _reqData = await FirebaseFirestore.instance
                            .collection('request')
                            .where('userId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .get();
                        if (_reqData.docs.length > 0) {
                          await FirebaseFirestore.instance
                              .collection('request')
                              .doc(_reqData.docs[0]['requestId'])
                              .delete();
                        }
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'tableNo': null,
                          'tableId': null,
                          'isRequestAccept': false,
                          'isRequestSent': false,
                        });
                      } catch (e) {
                        showOKDialogFlash(
                            context: context,
                            confirmText: 'ok',
                            content: Text(Constants.cancel_req_error),
                            confirmFunction: () {});
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: Container(
                      width: 110,
                      //height: 30,
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFFFF735C),
                      ),
                      child: (_isLoading)
                          ? threeBounceSpinkit
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.close,
                                  color: Colors.red[900],
                                  size: 30,
                                ),
                                Text(
                                  'Cancel...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              Gaps.vGap4,
              Gaps.hLine,
              Gaps.vGap4,
              AutoSizeText(
                'Request has been sent successfully...',
                maxLines: 1,
                style: TextStyles.textSize12,
              ),
              AutoSizeText(
                'be patience, till the manager will accept the request.',
                maxLines: 1,
                style: TextStyles.textSize12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
