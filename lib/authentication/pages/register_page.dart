import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurent_user/authentication/firebase/firebase_auth.dart';
import 'package:restaurent_user/authentication/widget/textfield.dart';
import 'package:restaurent_user/common/common.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/dimens.dart';
import 'package:restaurent_user/res/gaps.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/util/change_notifier_manage.dart';
import 'package:restaurent_user/widget/flash.dart';
import 'package:restaurent_user/widget/load_image.dart';
import 'package:restaurent_user/widget/loader.dart';
import 'package:restaurent_user/widget/my_appbar.dart';
import 'package:restaurent_user/widget/my_button.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with ChangeNotifierMixin<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText = FocusNode();
  bool _clickable = false;
  bool _isLoading = false;

  late File? _image;

  // Future<ImageSource> chooseImgSource(context) {
  //   return showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             TextButton(
  //               child: Text('camera'),
  //               onPressed: () {},
  //             ),
  //             TextButton(
  //               child: Text('gallary'),
  //               onPressed: () {},
  //             ),
  //           ],
  //         );
  //       });
  // }

  Future getImage() async {
    final pickedFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void removedImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Map<ChangeNotifier, List<VoidCallback>> changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>>{
      _nameController: callbacks,
      _passwordController: callbacks,
      _userController: callbacks,
      _nodeText: null,
      _nodeText1: null,
      _nodeText2: null,
    };
  }

  @override
  void initState() {
    super.initState();
    // _nameController.text = SpUtil.getString(Constant.email);
  }

  void _verify() {
    final String name = _nameController.text;
    final String password = _passwordController.text;
    final String username = _userController.text;
    bool clickable = true;
    if (name.isEmpty || !name.contains('@')) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }
    if (username.isEmpty || username.length < 2) {
      clickable = false;
    }

    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _login() async {
    var imgUrl;
    FocusScope.of(context).unfocus();
    print(DateTime.now().toString());
    setState(() {
      _isLoading = true;
    });
    // await FireBaseAuth.registeredUserWithEmail(
    //   name: _userController.text,
    //   email: _nameController.text,
    //   password: _passwordController.text,
    //   context: context,
    //   img: _image,
    // );
    try {
      final _auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _nameController.text, password: _passwordController.text);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(_auth.user!.uid)
          .set({
        'userId': _auth.user!.uid,
        'userEmail': _nameController.text,
        'userName': _userController.text,
        'isRequestAccept': false,
        'isRequestSent': false,
        'tableId': null,
        'tableNo': null,
      });
      Navigator.pop(context);
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
    } finally {
      setState(() {
        _isLoading = false;
      });

      print(DateTime.now().toString());
    }

    if (_image != null) {
      print('statrt' + DateTime.now().toString());
      final ref = FirebaseStorage.instance
          .ref()
          .child('profileImg')
          .child(_userController.text + '.jpg');
      await ref.putFile(_image!).whenComplete(() async {
        print(ref.toString());
        imgUrl = await ref.getDownloadURL();
      });
      print('gt' + DateTime.now().toString());
    }

    print('rfevr' + DateTime.now().toString());
    final _user = FirebaseAuth.instance.currentUser;
    await _user!.updateProfile(
      displayName: _userController.text,
      photoURL: (_image == null) ? null : imgUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          // title: Text('Authentication'),
          ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildBody,
          ),
        ),
      ),
    );
  }

  List<Widget> get _buildBody => [
        Text(
          'User Register',
          style: TextStyles.textBold26,
        ),
        (_image == null)
            ? ImageAddRemove.addImage(context, getImage)
            : ImageAddRemove.displayImage(_image, removedImage, context),
        Gaps.vGap16,
        MyTextField(
          controller: _userController,
          hintText: 'Enter your name',
          key: const Key('username'),
          focusNode: _nodeText,
        ),
        Gaps.vGap8,
        MyTextField(
          controller: _nameController,
          key: const Key('email'),
          focusNode: _nodeText1,
          keyboardType: TextInputType.emailAddress,
          hintText: 'Enter an email!',
        ),
        Gaps.vGap8,
        MyTextField(
          key: const Key('password'),
          keyName: 'password',
          focusNode: _nodeText2,
          isInputPwd: true,
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          maxLength: 16,
          hintText: 'make a stronge password!',
        ),
        Gaps.vGap10,
        MyButton(
          key: const Key('login'),
          text: _isLoading
              ? threBounceSpinKitWithWhite
              : Text(
                  'Login',
                  style: TextStyle(
                      fontSize: Dimens.font_sp18, color: Colors.white),
                ),
          onPressed: _clickable ? _login : null,
        ),
      ];
}
