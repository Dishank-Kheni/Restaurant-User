import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_user/common/common.dart';
import 'package:restaurent_user/home_page/function/place_order_fun.dart';
import 'package:restaurent_user/provider/product.dart';
import 'package:restaurent_user/provider/product_provider.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/gaps.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/util/screen_utill.dart';
import 'package:restaurent_user/widget/flash.dart';
import 'package:restaurent_user/widget/load_image.dart';
import 'package:restaurent_user/widget/loader.dart';

class ProductCartPage {
  static Future productCartPage(BuildContext context, _tableId, _tableNO) {
    final _provider = Provider.of<ProductProvider>(context, listen: false);
    var _cartOrders = _provider.getOrdersFromTheCart;
    Widget _tableNo = Container(
      // margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colours.app_main),
      padding: EdgeInsets.all(6),
      child: AutoSizeText(
        'Table No - ' + _tableNO.toString(),
        maxLines: 1,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );

    Widget _motto = Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText('We will', maxLines: 1, style: TextStyles.textBold24),
        Gaps.vGap5,
        AutoSizeText('deliver shortly!',
            maxLines: 1, style: TextStyles.textBold24),
        // for (var data in cartorder) orderCard(data),
      ],
    );

    return showMaterialModalBottomSheet(
        backgroundColor: Colours.bg_color,
        barrierColor: Colours.accent.withOpacity(0.9),
        context: context,
        builder: (context) {
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: ModalScrollController.of(context),
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 35, top: 25),
                    child: (_cartOrders.length <= 0)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/empty_cart.json',
                                  alignment: Alignment.center,
                                  //  height: Screen.height(context) * 0.5,
                                  fit: BoxFit.cover),
                              Text(Constants.cart_empty),
                              RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Add product'),
                              )
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _motto,
                              Gaps.vGap5,
                              for (var _product in _cartOrders)
                                CardProductWidget(
                                  _product,
                                ),
                            ],
                          ),
                  ),
                ),
                Align(alignment: Alignment.topCenter, child: _tableNo),
                (_cartOrders.length <= 0)
                    ? Container()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: CartOrderCount(_tableId, _tableNO)),
              ],
            ),
          );
        });
  }
}

class CardProductWidget extends StatefulWidget {
  final Product _product;
  CardProductWidget(
    this._product,
  );

  @override
  _CardProductWidgetState createState() => _CardProductWidgetState();
}

class _CardProductWidgetState extends State<CardProductWidget> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    final _leading = CircleAvatar(
      foregroundColor: Colors.transparent,
      radius: 40,
      backgroundColor: Colors.transparent,
      child: LoadImage(
        widget._product.img!,
        radius: 40,
      ),
    );

    Widget _title = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: Screen.width(context) * 0.5),
      child: AutoSizeText(
        widget._product.name!,
        maxLines: 1,
        style: TextStyles.textBold16,
      ),
    );

    Widget _subTitle = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: Screen.width(context) * 0.5),
      child: AutoSizeText(
        widget._product.weight!.toStringAsFixed(2) +
            ' gms/' +
            widget._product.qty.toString() +
            'pieces',
        maxLines: 1,
        style: TextStyles.textBold16,
      ),
    );

    Widget _cartOrder = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (widget._product.cart == 0) {
              return;
            }
            _provider.addOrderInCart(
              productId: widget._product.productid,
              orders: -1,
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 3, top: 3, right: 5),
            padding: EdgeInsets.all(3),
            child: Icon(
              Icons.remove,
            ),
            decoration: BoxDecoration(
              color: Colours.app_main,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        Text(
          widget._product.cart.toString(),
          style: TextStyles.textBold20,
        ),
        InkWell(
          onTap: () {
            _provider.addOrderInCart(
              productId: widget._product.productid,
              orders: 1,
            );
          },
          child: Container(
            margin: EdgeInsets.only(left: 5, bottom: 3, top: 3, right: 5),
            padding: EdgeInsets.all(3),
            child: Icon(
              Icons.add,
            ),
            decoration: BoxDecoration(
              color: Colours.app_main,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ],
    );

    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            _leading,
            Gaps.hGap8,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title,
                _subTitle,
                _cartOrder,
              ],
            ),
            Spacer(),
            AutoSizeText(
                '\$ ' +
                    '${((widget._product.price)! * (widget._product.cart!)).toStringAsFixed(1)}'
                        .toString(),
                style: TextStyles.textBold20),
          ],
        ),
      ),
    );
  }
}

class CartOrderCount extends StatefulWidget {
  CartOrderCount(
    this._tableId,
    this._tableNo,
  );
  final _tableId;
  final _tableNo;
  @override
  _CartOrderCountState createState() => _CartOrderCountState();
}

class _CartOrderCountState extends State<CartOrderCount> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      width: Screen.width(context) / 1.11,
      height: Screen.height(context) * 0.07,
      padding: EdgeInsets.symmetric(horizontal: 30),
      //width: double.infinity,
      // margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 8),
      decoration: BoxDecoration(
        color: Colours.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: (_isLoading)
          ? threBounceSpinKitWithWhite
          : InkWell(
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await PlaceOrderFun.placeOrderfun(
                      _provider, widget._tableId, widget._tableNo);
                  showOKDialogFlash(
                      context: context,
                      confirmFunction: () {},
                      confirmText: 'ok',
                      title: Column(
                        children: [
                          Text(Constants.order_placed),
                          Gaps.vGap4,
                          Gaps.hLine,
                          Gaps.vGap4,
                        ],
                      ),
                      content: Text(
                        Constants.order_placed_desc,
                        style: TextStyles.textGray16,
                      ));

                  showBasicsFlash(
                      context: context,
                      duration: Duration(seconds: 2),
                      message: Constants.order_placed);
                } catch (e) {
                  showOKDialogFlash(
                    context: context,
                    confirmFunction: () {},
                    confirmText: 'OK',
                    title: Text(
                      Constants.order_place_error,
                      style: TextStyle(
                          color: Colours.red, fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      e.toString(),
                      style: TextStyles.textGray12,
                    ),
                  );
                } finally {
                  setState(() {
                    Navigator.pop(context);
                    _isLoading = false;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Place order',
                    style: TextStyle(color: Colors.white),
                  ),
                  AutoSizeText(
                    '\$ ' + _provider.cartTotalAmount.toStringAsFixed(1),
                    maxLines: 1,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
    );
  }
}
