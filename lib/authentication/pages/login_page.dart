import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:restaurent_user/authentication/authentication_router.dart';
import 'package:restaurent_user/authentication/firebase/firebase_auth.dart';
import 'package:restaurent_user/authentication/widget/textfield.dart';
import 'package:restaurent_user/common/common.dart';
import 'package:restaurent_user/res/dimens.dart';
import 'package:restaurent_user/res/gaps.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/routers/routers.dart';
import 'package:restaurent_user/util/change_notifier_manage.dart';
import 'package:restaurent_user/widget/flash.dart';
import 'package:restaurent_user/widget/loader.dart';
import 'package:restaurent_user/widget/my_appbar.dart';
import 'package:restaurent_user/widget/my_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with ChangeNotifierMixin<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;
  bool _isLoading = false;

  @override
  Map<ChangeNotifier, List<VoidCallback>> changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>>{
      _nameController: callbacks,
      _passwordController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
    };
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = SpUtil.getString(Constants.userEmail)!;
  }

  void _verify() {
    final String name = _nameController.text;
    final String password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || !name.contains('@')) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  //manager login
  void _login() async {
    FocusScope.of(context).unfocus();
    String email = _nameController.text;
    String password = _passwordController.text;
    setState(() {
      _isLoading = true;
    });

    final _isUser = await FireBaseAuth.isUserRegestered(
      email: email,
    );
    // ignore: unrelated_type_equality_checks
    if (_isUser == false) {
      setState(() {
        _isLoading = false;
      });
      showOKDialogFlash(
          context: context,
          confirmText: 'ok',
          content: Text(Constants.authLogin_error),
          confirmFunction: () {});
      return;
    }

    await FireBaseAuth.signInWithEmail(
      email: email,
      password: password,
      context: context,
    );

    SpUtil.putString(Constants.userEmail, email);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          //title: Text('Authentication'),
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
          'User Login',
          style: TextStyles.textBold26,
        ),
        Gaps.vGap16,
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
        Gaps.vGap15,
        Container(
          alignment: Alignment.center,
          child: GestureDetector(
            child: Text(
              'No account yet? Register now',
              style: TextStyles.textSize12,
            ),
            onTap: () {
              Routes.router.navigateTo(context, Authentication.registerPage);
            },
          ),
        ),
      ];
}
