import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/gaps.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/util/screen_utill.dart';

class BillDetailPage extends StatelessWidget {
  final bill;
  BillDetailPage({this.bill});
  @override
  Widget build(BuildContext context) {
    Widget _billIdW = Container(
      margin: EdgeInsets.only(left: 3),
      child: AutoSizeText(
        'Bill - ' + bill['billId'],
        maxLines: 1,
        style: TextStyles.textBold14,
      ),
    );

    Widget _billPrimaryData = Card(
      // margin: EdgeInsets.all(8),
      elevation: 6,
      color: Colours.app_main,
      //
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: Screen.width(context) * 0.5),
                  child: AutoSizeText(
                    bill['userName'],
                    maxLines: 1,
                  ),
                ),
                Gaps.vGap16,
                ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: Screen.width(context) * 0.5),
                    child: AutoSizeText(
                      bill['userEmail'],
                      maxLines: 1,
                    )),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Date:26/02/21'),
                Gaps.vGap16,
                Text('Time:9:51'),
              ],
            ),
          ],
        ),
      ),
    );

    Widget _table = Container(
      // alignment: Alignment.center,
      margin: EdgeInsets.only(left: 3, top: 5),
      child: Table(
        textBaseline: TextBaseline.alphabetic,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {0: FixedColumnWidth(Screen.width(context) * 0.45)},
        children: [
          TableRow(children: [
            Text('Product'),
            Center(child: Text('Qty')),
            Center(child: Text('Price')),
            Center(child: Text('Total')),
          ]),
          for (var data in bill['billProduct'])
            TableRow(children: [
              Text(data['productName']),
              Center(child: Text(data['qty'].toString())),
              Center(child: Text(data['price'].toStringAsFixed(1))),
              Center(child: Text(data['totalPrice'].toStringAsFixed(1))),
            ]),
          TableRow(children: [
            Gaps.hLine,
            Gaps.hLine,
            Gaps.hLine,
            Gaps.hLine,
          ]),
          TableRow(children: [
            Text(''),
            Text(''),
            Text(''),
            Center(
              child: Text(bill['totalAmount'].toStringAsFixed(1),
                  style: TextStyles.textBold16),
            ),
          ]),
          TableRow(children: [
            Gaps.hLine,
            Gaps.hLine,
            Gaps.hLine,
            Gaps.hLine,
          ]),
        ],
      ),
    );

    Widget _approved = Container(
      margin: EdgeInsets.only(left: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Approved By'),
          Text('Lstrum'),
          Text('Lpsrum Restaurent'),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Orders'),
      ),
      body: Card(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _billIdW,
              Gaps.vGap16,
              _billPrimaryData,
              Gaps.vGap10,
              _table,
              Gaps.vGap32,
              _approved

              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Container(
              //       margin: EdgeInsets.only(right: 10),
              //       child: Text(bill['totalAmount'].toStringAsFixed(1))),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
