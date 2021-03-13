import 'package:dealerapp/Screens/mainScreen.dart';
import 'package:dealerapp/Screens/notAllowed.dart';
import 'package:dealerapp/Screens/registration.dart';
import 'package:dealerapp/login/phoneVerification.dart';
import 'package:dealerapp/login/rootPage.dart';
import 'package:dealerapp/login/userProvider.dart';
import 'package:dealerapp/models/userModel.dart';
import 'package:dealerapp/services/constant.dart';
import 'package:dealerapp/services/database.dart';
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
        } else if (myUser.accountType == "Customer" ||
            myUser.accountType == "Admin") {
          myUser
            ..reason =
                "You have A ${myUser.accountType} account , ask admin if you want to change Your account to Dealer Account";
          update(myUser);
          return NotAllowed();
        } else if (myUser.ids == null ||
            myUser.ids.length < 3 ||
            (myUser.ids[0] == null) ||
            (myUser.ids[1] == null) ||
            (myUser.ids[2] == null)) {
          return Registration();
        } else if (myUser.dealerId == null || myUser.dealerId == "") {
          myUser..reason = "Waiting for Approval";
          update(myUser);
          return NotAllowed();
        } else if (myUser.dealerId == "NONE") {
          myUser..reason = "Rejected , due to " + myUser.reason;
          update(myUser);
          return NotAllowed();
        } else {
          return StreamProvider<MyUser>.value(
              initialData: myUser,
              value: UserService(myUser.uid).userAccountData,
              builder: (context, child) => MainScreen());
        }
      },
    );
  }
}

void update(MyUser obj) async {
  await Hive.box<MyUser>(userBox).put("myuser", obj);
}
