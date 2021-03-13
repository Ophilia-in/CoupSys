import 'package:cached_network_image/cached_network_image.dart';
import 'package:electricianapp/Screens/profilePage.dart';
import 'package:electricianapp/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/constant.dart';
import '../pages/homePage.dart';

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

    if (!Hive.box<MyUser>(userBox).isOpen) Hive.openBox<MyUser>(userBox);
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
              Image.asset("assets/appBarLogo.png" , height: 50,)
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
                  child: CachedNetworkImage(
                        imageUrl: myUser.photoUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ) ??
                      Icon(
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
