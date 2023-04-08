import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurent_user/home_page/firebase/product_firebase.dart';
import 'package:restaurent_user/provider/product_provider.dart';

class PlaceOrderFun {
  static Future<void> placeOrderfun(
      ProductProvider _provider, _tableId, _tableNo) async {
    final _cartOrders = _provider.getOrdersFromTheCart;
    for (int i = 0; i < _cartOrders.length; i++) {
      await ProductFirebase.placeOrder(
          price: _cartOrders[i].price!,
          tableNo: int.parse(_tableNo.toString()),
          productName: _cartOrders[i].name!,
          userId: FirebaseAuth.instance.currentUser!.uid,
          tableId: _tableId,
          productId: _cartOrders[i].productid!,
          totalAmount: (_cartOrders[i].cart! * _cartOrders[i].price!),
          qty: _cartOrders[i].cart!,
          chefRemainingOrder: _cartOrders[i].cart!,
          currentPerformingOrder: 0);
      await ProductFirebase.updateProductTotalOrders(
          productId: _cartOrders[i].productid, orders: _cartOrders[i].cart);
      _provider.removeOrderFromTheCart(
        _cartOrders[i].productid!,
      );
    }
  }
}
