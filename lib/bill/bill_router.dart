import 'package:fluro/fluro.dart';
import 'package:restaurent_user/bill/pages/bill_page.dart';
import 'package:restaurent_user/routers/i_router.dart';

class BillRouter implements IRouterPovider {
  static final billpage = 'bill/billpage';
  void initRouter(FluroRouter router) {
    router.define(billpage,
        handler: Handler(handlerFunc: (_, __) => BillPage()));
  }
}
