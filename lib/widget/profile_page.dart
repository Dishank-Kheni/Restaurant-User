import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurent_user/common/common.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/gaps.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/util/screen_utill.dart';
import 'package:restaurent_user/widget/dialoag.dart';
import 'package:restaurent_user/widget/flash.dart';
import 'package:restaurent_user/widget/load_image.dart';
import 'package:restaurent_user/widget/loader.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  User? _user;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    assignUser();
    super.initState();
  }

  void assignUser() {
    _user = _auth.currentUser;
  }

  Future getImage() async {
    try {
      var imgUrl;
      final pickedFile = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 40, maxWidth: 200);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        final ref = FirebaseStorage.instance
            .ref()
            .child('profileImg')
            .child(_user!.displayName! + '.jpg');
        await ref.putFile(_image!).whenComplete(() async {
          print(ref.toString());
          imgUrl = await ref.getDownloadURL();
        });
        await _user?.updateProfile(
          photoURL: imgUrl,
        );
        setState(() {});
        showBasicsFlash(
            context: context,
            duration: Duration(seconds: 2),
            message: Constants.img_updation);
      } else {
        Dialoag.errorDialoag(
            context: context,
            title: Text(
              Constants.img_selection_error,
              maxLines: 1,
              style: TextStyles.textBold18,
            ),
            subContent: Text(
              Constants.img_selection_errorDesc, // e.toString(),
              maxLines: 4,
              style: TextStyles.textGray14,
            ));
      }
    } catch (e) {
      showOKDialogFlash(
          context: context,
          confirmFunction: () {},
          confirmText: 'ok',
          title: Text(
            Constants.img_upload_error,
            style: TextStyles.textBold16.copyWith(color: Colours.red),
          ),
          content: Text(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    assignUser();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }),
        title: AutoSizeText('Profile Updation page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          (_user!.photoURL == null)
              ? Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Add New Image :',
                            style: TextStyles.textBold16,
                          )),
                      Gaps.vGap4,
                      Gaps.hLine,
                      Gaps.vGap4,
                      AddImage(
                        context: context,
                        getImage: getImage,
                      )
                      //ImageAddRemove.addImage(context, getImage),
                    ],
                  ),
                )
              : Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Change The Image :',
                            style: TextStyles.textBold16,
                          )),
                      Gaps.vGap4,
                      Gaps.hLine,
                      Gaps.vGap4,
                      DisplayNetWorkImg(
                          image: _user!.photoURL,
                          removedImage: getImage,
                          context: context,
                          imgType: 'change img'),
                    ],
                  ),
                ),
          Gaps.vGap15,
          Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Update Display Name :',
                      style: TextStyles.textBold16,
                    )),
                Gaps.vGap4,
                Gaps.hLine,
                Gaps.vGap4,
                GestureDetector(
                  onTap: () async {
                    await updateName(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: Screen.width(context) * 0.7),
                          child: AutoSizeText(
                            _user!.displayName!,
                            maxLines: 1,
                            style: TextStyles.textBold14,
                          ),
                        ),
                        Icon(Icons.edit),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future updateEmail(BuildContext context) {
    String email;
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Text('Enter new email'),
                  Gaps.vGap10,
                  TextFormField(
                    autofocus: true,
                    onChanged: (val) {
                      email = val;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('CANCEL'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {} catch (e) {
                            print(e);
                          }
                          Navigator.pop(context);

                          setState(() {});
                        },
                        child: Text('SAVE'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  updateName(BuildContext context) async {
    String? name = _user!.displayName;
    bool _isLoading = false;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  Text(
                    'Enter your name',
                    style: TextStyles.textBold16,
                  ),
                  Gaps.vGap10,
                  TextFormField(
                    cursorColor: Colours.accent,
                    style: TextStyles.textBold14,
                    initialValue: name,
                    autofocus: true,
                    onChanged: (val) {
                      name = val;
                    },
                  ),
                  (_isLoading)
                      ? Container(
                          child: threeBounceSpinkit,
                          margin: EdgeInsets.all(5),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'CANCEL',
                                style: TextStyle(color: Colours.accent),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await _user!.updateProfile(displayName: name);
                                  showBasicsFlash(
                                      context: context,
                                      duration: Duration(seconds: 2),
                                      message: Constants.name_updation);
                                } catch (e) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showOKDialogFlash(
                                      context: context,
                                      confirmFunction: () {},
                                      confirmText: 'ok',
                                      title: Text(
                                        Constants.name_updation_error,
                                        style: TextStyles.textBold16
                                            .copyWith(color: Colours.red),
                                      ),
                                      content: Text(e.toString()));
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                'SAVE',
                                style: TextStyle(color: Colours.accent),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        });
  }
}

/*
SingleChildScrollView(
          child: Column(
            children: [
              (_image == null)
                  ? ImageAddRemove.addImage(context, getImage)
                  : ImageAddRemove.displayImage(_image, removedImage, context),
            ],
          ),
        )*/
