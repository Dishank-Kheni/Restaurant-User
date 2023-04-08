import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_user/authentication/pages/email_verified_page.dart';
import 'package:restaurent_user/authentication/pages/login_page.dart';
import 'package:restaurent_user/home_page/pages/home_page.dart';
import 'package:restaurent_user/provider/product_provider.dart';
import 'package:restaurent_user/provider/theme_provider.dart';
import 'package:restaurent_user/routers/routers.dart';
import 'package:restaurent_user/widget/loader.dart';
import 'package:restaurent_user/widget/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key) {
    Routes.initRoutes();
  }
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
      ],
      child: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting)
            return MaterialApp(home: SplashScreen());
          else {
            User? user;
            final _auth = FirebaseAuth.instance;
            Future<void> checkEmailVerified() async {
              user = _auth.currentUser;
              await user?.reload();
            }

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeProvider.getTheme(),
              navigatorKey: navigatorKey,
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasError)
                    return Scaffold(body: threeBounceSpinkit);
                  if (snapshot.hasData) {
                    checkEmailVerified();
                    if (user!.emailVerified) {
                      return HomePage();
                    } else
                      return EmailVerified();
                  } else {
                    return LoginPage();
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
