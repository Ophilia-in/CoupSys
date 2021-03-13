import 'package:cached_network_image/cached_network_image.dart';
import 'package:dealerapp/login/rootPage.dart';
import 'package:dealerapp/login/userProvider.dart';
import 'package:dealerapp/services/constant.dart';
import 'package:dealerapp/models/userModel.dart';
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
        backgroundColor: Colors.blue[300],
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
                            size: 100.0,
                            color: Colors.grey,
                          )),
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
              leading: Icon(Icons.business),
              title: Text("Firm Name"),
              subtitle: Text(myUser.firmName ?? "Not Available"),
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
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text("Dealer Id"),
              subtitle: Text(myUser.dealerId),
            ),
            // ListTile(
            //     leading: Icon(Icons.receipt),
            //     title: Text("View TransactionRecords"),
            //     subtitle: Text("Tap to View"),
            //     onTap: () => Navigator.push(
            //           context,
            //           CupertinoPageRoute(builder: (context) => TransactionRecords()),
            //         )),
            ListTile(
              leading: Icon(Icons.help),
              trailing: IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: _width / 20,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(actions: [
                        FlatButton(
                          child: Text("Okay"),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ], content: Text("Contact 8638741516 for Support"));
                    },
                  );
                },
              ),
              title: Text("Contact Us"),
            )
          ],
        ),
      )),
    );
  }
}
