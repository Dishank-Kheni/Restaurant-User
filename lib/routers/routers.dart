import 'package:fluro/fluro.dart';
import 'package:restaurent_user/authentication/authentication_router.dart';
import 'package:restaurent_user/bill/bill_router.dart';
import 'package:restaurent_user/home_page/home_page_router.dart';
import 'package:restaurent_user/routers/i_router.dart';

class Routes {
  static final List<IRouterPovider> _listRouter = [];

  static final FluroRouter router = FluroRouter();

  static void initRoutes() {
    _listRouter.clear();
    _listRouter.add(Authentication());
    _listRouter.add(HomePageRouter());
    _listRouter.add(BillRouter());
    _listRouter.forEach((routerProvider) {
      routerProvider.initRouter(router);
    });
  }
}
