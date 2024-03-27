import 'package:flutter/material.dart';
import 'package:food_pj/login.dart';
import 'package:food_pj/register.dart';
import 'package:food_pj/home.dart';
import 'package:food_pj/user_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PersistentShoppingCart().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return buildMaterialApp();
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home':(context) => Homepage(),
        '/uinfo': (context) => PersonalInfoPage()
      },
    );
  }
}
