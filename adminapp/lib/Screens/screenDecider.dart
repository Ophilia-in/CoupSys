import 'package:adminapp/Screens/mainScreen.dart';
import 'package:adminapp/Screens/notAllowed.dart';
import 'package:adminapp/login/rootPage.dart';
import 'package:adminapp/login/userProvider.dart';
import 'package:adminapp/models/transactionModel.dart';
import 'package:adminapp/models/userModel.dart';
import 'package:adminapp/services/constant.dart';
import 'package:adminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  void initState() {
    super.initState();
  }

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
                    "Some Error Occurred!! , Please Log Out and Log In Again")),
          );
        }
        if (myUser.reason == "." || myUser.name == "Unknown") {
          myUser
            ..reason =
                "You have been somehow able to reach till here but are not allowed further";
          update(myUser);
          return NotAllowed();
        } else {
          return MultiProvider(providers: [
            StreamProvider<List<TransactionRecord>>.value(
                initialData: [],
                value: FirebaseFirestore.instance
                    .collection("Member")
                    .doc(dbAdminUiD)
                    .collection("passbook")
                    .orderBy('date', descending: true)
                    .limit(10)
                    .snapshots()
                    .map(transactionRecordFromSnapshots))
          ], child: MainScreen());
        }
      },
    );
  }
}
