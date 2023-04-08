import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_user/provider/product.dart';
import 'package:restaurent_user/provider/product_provider.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/gaps.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/util/screen_utill.dart';
import 'package:restaurent_user/widget/load_image.dart';

class ProductOrderPage {
  static Future productOrderPage(
    BuildContext context,
    Product product,
  ) {
    Widget nutritionDetail(String value, String type, BuildContext context) {
      double _val = double.parse(value);
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _val.toStringAsFixed(1),
            style: TextStyles.textBold14,
          ),
          Gaps.vGap4,
          Text(
            type,
            style: TextStyles.textSize12,
          )
        ],
      );
    }

    Widget _title = AutoSizeText(
      product.name!,
      maxLines: 1,
      style: TextStyles.textBold20,
    );

    Widget _subTitle = AutoSizeText(
      product.description!,
      maxLines: 3,
      style: TextStyles.textGray16,
    );

    Widget _subTitle1(List eI) {
      String _item = "";
      for (int i = 0; i < eI.length; i++) {
        (eI.length == i + 1)
            ? _item = _item + eI[i].toString() + '.'
            : _item = _item + eI[i].toString() + ', ';
      }
      return (eI.length == 0)
          ? Text('No extra item')
          : AutoSizeText(
              _item,
              maxLines: 1,
              style: TextStyles.textGray16,
            );
    }

    Widget _leading = CircleAvatar(
      child: LoadImage(product.img!, radius: Screen.width(context) * 0.2),
      radius: Screen.width(context) * 0.2,
    );

    Widget _nutritionDetail = Card(
      // margin: EdgeInsets.only(top: Dimens.gap_dp12),
      color: Colours.app_main,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            nutritionDetail(product.nutrition!['kcal'], 'kcal', context),
            nutritionDetail(product.nutrition!['grams'], 'grams', context),
            nutritionDetail(
                product.nutrition!['proteins'], 'proteins', context),
            nutritionDetail(product.nutrition!['fats'], 'fats', context),
            nutritionDetail(product.nutrition!['carbs'], 'carbs', context),
          ],
        ),
      ),
    );

    Widget _weightDetail = Card(
      child: Container(
        height: 54,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weight  ',
              style: TextStyles.textBold16,
            ),
            Gaps.hGap10,
            Text(
              product.weight!.toStringAsFixed(2),
              style: TextStyles.textSize16,
            ),
          ],
        ),
      ),
    );

    Widget _vegDetail = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Vegetarian',
              style: TextStyles.textBold18,
            ),
            CupertinoSwitch(
              value: product.vegitarian!,
              activeColor: Colors.green,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );

    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        barrierColor: Colours.accent.withOpacity(0.92),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(8),
              height: Screen.height(context) * 0.92,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // color: Colors.yellow,
                    height: Screen.height(context) * 0.9 - 85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: _leading),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _title,
                            Gaps.vGap8,
                            _subTitle,
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Extra Item',
                              style: TextStyles.textBold20,
                            ),
                            Gaps.vGap5,
                            _subTitle1(product.extraItem!)
                          ],
                        ),
                        _nutritionDetail,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _weightDetail,
                            Expanded(
                              child: _vegDetail,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Gaps.hLine,
                  ProductOrderCount(product)
                ],
              ),
            ),

            //  ],
            // ),
          );
        });
  }
}

class ProductOrderCount extends StatefulWidget {
  ProductOrderCount(
    this.product,
  );

  final Product product;
  @override
  _ProductOrderCountState createState() => _ProductOrderCountState();
}

class _ProductOrderCountState extends State<ProductOrderCount> {
  int temp = 1;
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          color: Colours.app_main,
          elevation: 3,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                ),
                onPressed: () {
                  if (widget.product.currentOrder == 1) {
                    return;
                  }
                  setState(() {
                    widget.product.currentOrder--;
                  });
                },
              ),
              Text(widget.product.currentOrder.toString()),
              IconButton(
                icon: Icon(
                  Icons.add,
                  //color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    widget.product.currentOrder++;
                  });
                },
              ),
            ],
          ),
        ),
        InkWell(
          child: Card(
            elevation: 3,
            color: Colours.accent,
            child: Container(
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                  Gaps.hGap8,
                  Text(
                      ' ' +
                          '\$${(widget.product.currentOrder * widget.product.price!).toStringAsFixed(1)}',
                      //     '\$${widget.product.currentOrder * widget.product.price}',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          onTap: () async {
            _provider.addOrderInCart(
              productId: widget.product.productid,
              orders: widget.product.currentOrder,
            );
            widget.product.currentOrder = 1;
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
