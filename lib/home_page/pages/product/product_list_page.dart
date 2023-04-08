import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurent_user/common/common.dart';
import 'package:restaurent_user/home_page/pages/product/product_cart_page.dart';
import 'package:restaurent_user/home_page/pages/product/product_order_page.dart';
import 'package:restaurent_user/provider/product.dart';
import 'package:restaurent_user/provider/product_provider.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/gaps.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/util/screen_utill.dart';
import 'package:restaurent_user/widget/load_image.dart';
import 'package:restaurent_user/widget/loader.dart';

class ProductListPage extends StatelessWidget {
  String? _tableId;
  int? _tableNo;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_bag),
        onPressed: () {
          ProductCartPage.productCartPage(context, _tableId, _tableNo);
        },
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
            return threeBounceSpinkit;
          } else {
            _tableId = snapshot.data['tableId'];
            _tableNo = snapshot.data['tableNo'];
            return StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('product').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return threeBounceSpinkit;
                } else {
                  _provider.clearProductBucket();
                  final _productData = snapshot.data?.docs;

                  for (var data in _productData) {
                    // print(_tableId);
                    int? temp = SpUtil.getInt(data['productId']);

                    //      print(data['productName'] + ' ' + temp.toString());

                    _provider.addProduct(Product(
                        cart: temp,
                        description: data['description'],
                        extraItem: data['extraItem'],
                        nutrition: data['nutrition'],
                        productid: data['productId'],
                        name: data['productName'],
                        price: double.parse(data['price'].toString()),
                        qty: data['qty'],
                        weight: double.parse(data['weight'].toString()),
                        vegitarian: data['vegetarian'],
                        origin: data['origin'],
                        img: data['img']));
                  }

                  return Consumer<ProductProvider>(
                    builder: (context, _provider, child) {
                      return (_provider.productlist.length <= 0)
                          ? Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: [
                                  Lottie.asset('assets/product_not_found.json',
                                      alignment: Alignment.center,
                                      height: Screen.height(context) * 0.5,
                                      fit: BoxFit.cover),
                                  //    DataNotFound.dataNotFoundImg(context),
                                  Gaps.hLine,
                                  Text(Constants.product_not_found),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _provider.productlist.length,
                              itemBuilder: (context, i) {
                                var _prodProvider = _provider.productlist[i];
                                final _leading = CircleAvatar(
                                  foregroundColor: Colors.transparent,
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  child: LoadImage(
                                    _prodProvider.img!,
                                    radius: 40,
                                  ),
                                );

                                Widget _title = ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: Screen.width(context) * 0.5),
                                  child: AutoSizeText(
                                    _prodProvider.name!,
                                    maxLines: 1,
                                    style: TextStyles.textBold16,
                                  ),
                                );

                                Widget _subTitle = ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: Screen.width(context) * 0.5),
                                  child: AutoSizeText(
                                    _prodProvider.weight!.toStringAsFixed(2) +
                                        ' gms/' +
                                        _prodProvider.qty.toString() +
                                        'pieces',
                                    maxLines: 1,
                                    style: TextStyles.textBold16,
                                  ),
                                );

                                Widget _productOrder = Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 7),
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colours.app_main),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_bag,
                                      ),
                                      Gaps.hGap8,
                                      Text(
                                        _prodProvider.cart.toString(),
                                        style: TextStyles.textBold20,
                                      ),
                                    ],
                                  ),
                                );

                                Widget _action = Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          ProductOrderPage.productOrderPage(
                                            context,
                                            _prodProvider,
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.add,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colours.app_main,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                      ),
                                      Gaps.vGap10,
                                      Text(
                                        _prodProvider.price!.toStringAsFixed(1),
                                        style: TextStyles.textBold14,
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(Icons.expand_more),
                                      )
                                    ],
                                  ),
                                );

                                return Card(
                                  margin: EdgeInsets.all(10),
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        _leading,
                                        Gaps.hGap8,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _title,
                                            _subTitle,
                                            _productOrder,
                                          ],
                                        ),
                                        Spacer(),
                                        _action,
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
