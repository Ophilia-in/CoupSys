import 'package:electricianapp/Screens/mainScreen.dart';
import 'package:electricianapp/Screens/notAllowed.dart';
import 'package:electricianapp/login/phoneVerification.dart';
import 'package:electricianapp/login/rootPage.dart';
import 'package:electricianapp/login/userProvider.dart';
import 'package:electricianapp/models/userModel.dart';
import 'package:electricianapp/services/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class Decider extends StatefulWidget {
  const Decider({Key key}) : super(key: key);

  @override
  _DeciderState createState() => _DeciderState();
}

class _DeciderState extends State<Decider> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context, listen: false);
    return ValueListenableBuilder(
      valueListenable: Hive.box<MyUser>(userBox).listenable(),
      builder: (context, Box<MyUser> box, child) {
        final myUser = box.get("myuser");
        if (box.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Error"),
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
            body: Center(
                child: Text(
                    "Please Wait!! Some Error Occurred!! or your internet connection is weak  , Trying  to Automatically fix . Please Log Out and Log In Again")),
          );
        }

        if (FirebaseAuth.instance.currentUser.phoneNumber == null ||
            FirebaseAuth.instance.currentUser.phoneNumber == "") {
          return PhoneVerification();
        } else if (myUser.accountType == "Retailer" ||
            myUser.accountType == "Dealer" ||
            myUser.accountType == "Admin") {
          myUser
            ..reason =
                "You have A ${myUser.accountType} account , ask admin if you want to change Your account to Electrician Account";
          update(myUser);
          return NotAllowed();
        } else {
          return MainScreen();
        }
      },
    );
  }
}

void update(MyUser obj) async {
  await Hive.box<MyUser>(userBox).put("myuser", obj);
}
