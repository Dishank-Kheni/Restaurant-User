import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurent_user/home_page/pages/message_page.dart';
import 'package:restaurent_user/home_page/pages/product/product_list_page.dart';
import 'package:restaurent_user/home_page/pages/scanner_page.dart';
import 'package:restaurent_user/widget/drawer.dart';
import 'package:restaurent_user/widget/load_image.dart';
import 'package:restaurent_user/widget/loader.dart';
import 'package:restaurent_user/widget/my_appbar.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      //  backgroundColor: Colours.bg_color,
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
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: CircleAvatar(
                  child: (user.photoURL == null)
                      ? Image.asset('assets/none.png')
                      : LoadImage(user.photoURL!)),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting)
              return threeBounceSpinkit;
            else {
              final _userData = snapshot.data;

              if (_userData['isRequestSent'] != true) return Scanner();

              ///scanner page
              if (_userData['isRequestSent'] == true &&
                  _userData['isRequestAccept'] == false) return MessagePage();

              ///message page
              if (_userData['isRequestAccept'] == true)
                return ProductListPage(); //product
              return threeBounceSpinkit; //default page
            }
          }),
    );
  }
}
