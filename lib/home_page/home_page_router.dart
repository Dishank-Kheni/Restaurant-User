import 'package:fluro/fluro.dart';
import 'package:restaurent_user/home_page/pages/home_page.dart';
import 'package:restaurent_user/routers/i_router.dart';

class HomePageRouter implements IRouterPovider {
  static final homepage = 'home/homepage';

  void initRouter(FluroRouter router) {
    router.define(homepage,
        handler: Handler(handlerFunc: (_, __) => HomePage()));
  }
}
