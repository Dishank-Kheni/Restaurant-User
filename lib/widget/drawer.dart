import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:restaurent_user/bill/bill_router.dart';
import 'package:restaurent_user/common/common.dart';
import 'package:restaurent_user/home_page/home_page_router.dart';
import 'package:restaurent_user/res/gaps.dart';
import 'package:restaurent_user/res/style.dart';
import 'package:restaurent_user/routers/routers.dart';
import 'package:restaurent_user/util/screen_utill.dart';
import 'package:restaurent_user/widget/flash.dart';
import 'package:restaurent_user/widget/load_image.dart';
import 'package:restaurent_user/widget/profile_page.dart';

// ignore: must_be_immutable
class UserDrawer extends StatelessWidget {
  User? user;
  final _auth = FirebaseAuth.instance;
  UserDrawer() {
    assignUser();
  }

  void assignUser() async {
    user = _auth.currentUser!;
    await user!.reload();
  }

  @override
  Widget build(BuildContext context) {
    assignUser();
    return SafeArea(
      child: Container(
        width: Screen.width(context) * 0.75,
        child: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        showConfirmDialogFlash(
                            context: context,
                            confirmFunction: () {
                              FirebaseAuth.instance.signOut();
                            },
                            title: Column(
                              children: [
                                Text(Constants.sign_out_warn),
                                Gaps.vGap4,
                                Gaps.hLine,
                                Gaps.vGap4,
                              ],
                            ),
                            content: Text(
                              Constants.sign_out_warnDesc,
                              style: TextStyles.textGray14,
                            ),
                            confirmText: 'Sign Out',
                            cancelFunction: () {},
                            cancelText: 'Cancel');
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: Screen.width(context) * 0.1,
                            child: (user!.photoURL == null)
                                ? Image.asset('assets/none.png')
                                : LoadImage(user!.photoURL!,
                                    radius: Screen.width(context) * 0.1),
                          ),
                          Gaps.hGap8,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: Screen.width(context) * 0.4),
                                child: AutoSizeText(
                                  user!.displayName!,
                                  maxLines: 1,
                                  style: TextStyles.textBold18,
                                ),
                              ),
                              Gaps.vGap4,
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: Screen.width(context) * 0.4),
                                child: AutoSizeText(
                                  user!.email!,
                                  maxLines: 1,
                                  style: TextStyles.textGray14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //  Gaps.hLine,
                Gaps.vGap4,
                Card(
                  elevation: 0,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Home'),
                        onTap: () {
                          Routes.router.navigateTo(
                              context, HomePageRouter.homepage,
                              clearStack: true);
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Bill',
                          textAlign: TextAlign.start,
                        ),
                        onTap: () {
                          Routes.router.navigateTo(context, BillRouter.billpage,
                              clearStack: false);
                        },
                      ),
                      ListTile(
                        title: Text('Privacy'),
                        onTap: () {
                          // Routes.router.navigateTo(context, BillRouter.billpage,
                          //     cl
                          //earStack: true);
                        },
                      ),
                      ListTile(
                        title: Text('sign out'),
                        onTap: () {
                          showConfirmDialogFlash(
                              context: context,
                              confirmFunction: () {
                                FirebaseAuth.instance.signOut();
                              },
                              title: Column(
                                children: [
                                  Text(Constants.sign_out_warn),
                                  Gaps.vGap4,
                                  Gaps.hLine,
                                  Gaps.vGap4,
                                ],
                              ),
                              content: Text(
                                Constants.sign_out_warnDesc,
                                style: TextStyles.textGray14,
                              ),
                              confirmText: 'Sign Out',
                              cancelFunction: () {},
                              cancelText: 'Cancel');
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
