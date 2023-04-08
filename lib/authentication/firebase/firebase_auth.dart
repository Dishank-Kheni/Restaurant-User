import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurent_user/common/common.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/widget/flash.dart';

class FireBaseAuth {
  static Future<bool> isUserRegestered({required String email}) async {
    try {
      final _user = await FirebaseFirestore.instance
          .collection('user')
          .where('userEmail', isEqualTo: email)
          .get();
      if (_user.docs.length == 0)
        return false;
      else
        return true;
    } catch (e) {
      return false;
    }
  }

  static Future signInWithEmail(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // print('efdref' + ' signup successfully!');
      // return true;
    } catch (e) {
      showOKDialogFlash(
        context: context,
        confirmFunction: () {},
        confirmText: 'OK',
        title: Text(
          Constants.failed_login,
          style: TextStyles.textBold16.copyWith(color: Colours.red),
        ),
        content: Text(
          e.toString(),
        ),
      );
    }
  }

  // ignore: top_level_function_literal_block
  static Future registeredUserWithEmail({
    required String email,
    required String password,
    required String name,
    required File img,
    required BuildContext context,
  }) async {
    var imgUrl;
    try {
      print(DateTime.now().toString());

      final _auth = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (img != null) {
        print('statrt' + DateTime.now().toString());
        final ref = FirebaseStorage.instance
            .ref()
            .child('profileImg')
            .child(name + '.jpg');
        await ref.putFile(img).whenComplete(() async {
          print(ref.toString());
          imgUrl = await ref.getDownloadURL();
        });
        print('gt' + DateTime.now().toString());
      }

      await FirebaseFirestore.instance
          .collection('user')
          .doc(_auth.user!.uid)
          .set({
        'userId': _auth.user!.uid,
        'userEmail': email,
        'userName': name,
        'isRequestAccept': false,
        'isRequestSent': false,
        'tableId': null,
        'tableNo': null,
      });
      print('rfevr' + DateTime.now().toString());
      final _user = FirebaseAuth.instance.currentUser;
      await _user!.updateProfile(
        displayName: name,
        photoURL: (img == null) ? null : imgUrl,
      );
      print('registered succefully...');
      print('ere' + DateTime.now().toString());
      SpUtil.putString(Constants.userEmail, email);
      //   return true;
    } catch (e) {
      showOKDialogFlash(
          context: context,
          confirmFunction: () {},
          confirmText: 'ok',
          title: Text(
            Constants.failed_register,
            style: TextStyles.textBold16.copyWith(color: Colours.red),
          ),
          content: Text(e.toString()));

      //  return e;
    }
  }
}
