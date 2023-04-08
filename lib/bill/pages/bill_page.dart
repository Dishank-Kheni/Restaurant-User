import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurent_user/bill/pages/bill_detail_page.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/res/gaps.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/util/screen_utill.dart';
import 'package:restaurent_user/widget/drawer.dart';
import 'package:restaurent_user/widget/load_image.dart';
import 'package:restaurent_user/widget/loader.dart';
import 'package:restaurent_user/widget/my_appbar.dart';

class BillPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      drawer: UserDrawer(),
      appBar: MyAppBar(
        title: Text('Lpsrum Restaurent'),
        leading: IconButton(
          icon: Icon(Icons.dashboard),
          // color: Theme.of(context).primaryColor,
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(3),
            child: IconButton(
              icon: Icon(
                Icons.search,
                //color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: CircleAvatar(
                child: LoadImage(_user!.photoURL!),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('bill')
              .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.hasError ||
                snapshot.connectionState == ConnectionState.waiting)
              return threeBounceSpinkit;
            else {
              final _billData = snapshot.data?.docs;
              return (_billData.length <= 0)
                  ? Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/bill_not_found.json',
                            alignment: Alignment.center,
                            //  height: Screen.height(context) * 0.5,
                            //  fit: BoxFit.cover
                          ),
                          //    DataNotFound.dataNotFoundImg(context),
                          Gaps.hLine,
                          Text('There\'s no any bill generated yet!'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _billData.length,
                      itemBuilder: (context, i) {
                        Widget _leading = CircleAvatar(
                          backgroundColor: Colours.app_main,
                          radius: 32,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              _billData[i]['tableNo'].toString(),
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colours.accent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );

                        Widget _title = ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: Screen.width(context) * 0.55),
                          child: AutoSizeText(
                            _billData[i]['billId'],
                            maxLines: 1,
                            style: TextStyles.textBold14,
                          ),
                        );

                        Widget _subTitle1 = ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: Screen.width(context) * 0.55),
                          child: AutoSizeText(
                            _billData[i]['userName'],
                            maxLines: 1,
                            //style: TextStyles.textGray14,
                          ),
                        );

                        Widget _subTitle2 = ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: Screen.width(context) * 0.55),
                          child: AutoSizeText(
                            _billData[i]['userEmail'],
                            maxLines: 1,
                            style: TextStyles.textGray14,
                          ),
                        );

                        Widget _action = ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 60),
                          child: AutoSizeText(
                            '\$' +
                                _billData[i]['totalAmount'].toStringAsFixed(0),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyles.textBold18,
                          ),
                        );
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BillDetailPage(
                                  bill: _billData[i],
                                ),
                              ),
                            );
                            // Routes.router.navigateTo(
                            //     context, BillRouter.billDetailPage + _billData[i]);
                          },
                          child: Card(
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  _leading,
                                  Gaps.hGap10,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _title,
                                      _subTitle1,
                                      _subTitle2,
                                    ],
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: _action,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
            }
          }),
    );
  }
}
