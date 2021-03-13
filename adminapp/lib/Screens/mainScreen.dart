import 'package:adminapp/Screens/profilePage.dart';
import 'package:adminapp/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/constant.dart';
import 'homePage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");

  @override
  void initState() {
    super.initState();
    if (!Hive.box<MyUser>(userBox).isOpen) {
      Hive.openBox<MyUser>(userBox);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          titleSpacing: 10,
          toolbarHeight: 50,
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/appBarLogo.png",
                height: 50,
              )
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ProfilePage())),
              child: Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Hero(
                  tag: "profile",
                  child: Icon(
                    Icons.account_circle,
                    size: 50.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          ],
        ),
        body: HomePage());
  }
}
