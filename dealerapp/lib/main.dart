import 'package:dealerapp/login/rootPage.dart';
import 'package:dealerapp/login/userProvider.dart';
import 'package:dealerapp/models/userModel.dart';
import 'package:dealerapp/services/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MyUserAdapter());
  await Hive.openBox<MyUser>(userBox);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserRepository(),
          ),
        ],
        child: MaterialApp(
            title: "Flutter Demo",
            debugShowCheckedModeBanner: false,
            home: RootPage()));
  }
}
