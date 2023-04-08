import 'package:fluro/fluro.dart';
import 'package:restaurent_user/authentication/pages/login_page.dart';
import 'package:restaurent_user/authentication/pages/register_page.dart';
import 'package:restaurent_user/routers/i_router.dart';

class Authentication implements IRouterPovider {
  static final loginPage = 'user/login';
  static final registerPage = 'user/register';

  void initRouter(FluroRouter router) {
    router.define(loginPage,
        handler: Handler(handlerFunc: (_, __) => LoginPage()));

    router.define(registerPage,
        handler: Handler(handlerFunc: (_, __) => RegisterPage()));
  }
}
