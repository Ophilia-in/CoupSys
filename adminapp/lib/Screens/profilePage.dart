import 'package:adminapp/login/rootPage.dart';
import 'package:adminapp/login/userProvider.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:adminapp/services/constant.dart';
import 'package:adminapp/models/userModel.dart';
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
    final user = Provider.of<UserRepository>(context, listen: false);
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
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
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 100.0,
                    color: Colors.grey,
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
                        child:
                            Text("Created At " + myUser.createdAt.toString()),
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
              leading: Icon(Icons.perm_identity),
              title: Text("Unique Id"),
              subtitle: Text(myUser.uid),
            ),
            ListTile(
              leading: Icon(Icons.timer),
              title: Text("Created At"),
              subtitle:
                  Text(DateFormat('dd MMM y kk:mm').format(myUser.createdAt)),
            ),
          ],
        ),
      )),
    );
  }
}
