import 'package:cached_network_image/cached_network_image.dart';
import 'package:electricianapp/login/rootPage.dart';
import 'package:electricianapp/login/userProvider.dart';
import 'package:electricianapp/services/constant.dart';
import 'package:electricianapp/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    final user = Provider.of<UserRepository>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Profile"),
        actions: [
          FlatButton(
            child: Text("LogOut"),
            onPressed: () {
              user.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RootPage()),
                  (route) => false);
            },
          )
        ],
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _height / 100,
            ),
            SizedBox(
              height: _height / 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Hero(
                    tag: "profile",
                    child: CachedNetworkImage(
                          imageUrl: myUser.photoUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 100,
                            width: 100,
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
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ) ??
                        Icon(
                          Icons.account_circle,
                          size: 200.0,
                          color: Colors.grey,
                        ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: (_width / 20),
                        ),
                        child: Text(
                          myUser.name,
                          style: TextStyle(
                            fontSize: _width / 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: _width / 20),
                        child: Text(myUser.phone.toString()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _height / 30,
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text("Email"),
              subtitle: Text(myUser.email),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text("Points"),
              subtitle: Text(myUser.points.toString()),
            )
          ],
        ),
      )),
    );
  }
}
