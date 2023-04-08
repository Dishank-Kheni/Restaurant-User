import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:restaurent_user/provider/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> productlist = [];
  void addProduct(Product p) {
    print('add');
    productlist.add(p);
    //notifyListeners();
  }

  void addOrderInCart({String? productId, int? orders}) {
    var p = productlist.indexWhere((element) => element.productid == productId);
    productlist[p].cart = productlist[p].cart! + orders!;
    SpUtil.putInt(productId!, productlist[p].cart!);
    notifyListeners();
  }

  void removeOrderFromTheCart(String productId) {
    var p = productlist.indexWhere((element) => element.productid == productId);
    print('before cart' + productlist[p].cart.toString());
    productlist[p].cart = 0;
    print('cart' + productlist[p].cart.toString());
    SpUtil.putInt(productId, productlist[p].cart!);
    notifyListeners();
  }

  List<Product> get getOrdersFromTheCart {
    return productlist.where((e) => e.cart! > 0).toList();
  }

  void clearProductBucket() {
    productlist = [];
    // notifyListeners();
  }

  double get cartTotalAmount {
    double sum = 0;
    for (var data in productlist) {
      if (data.cart! > 0) sum = sum + (data.price! * data.cart!);
    }
    return sum;
  }
}
