import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adminapp/login/rootPage.dart';
import 'package:adminapp/login/userProvider.dart';
import 'package:adminapp/models/userModel.dart';
import 'package:adminapp/services/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class NotAllowed extends StatelessWidget {
  final inst = FirebaseAuth.instance;
  final fi = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Waiting For Access")),
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.teal,
        body: ValueListenableBuilder(
            valueListenable: Hive.box<MyUser>(userBox).listenable(),
            builder: (context, Box<MyUser> value, child) {
              MyUser myUser = value.get("myuser");
              if (value.isEmpty) {
                return Column(
                  children: [
                    Text("Some Error Occured!! Clear App Data"),
                  ],
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome!! You are not allowed to access the app because :",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    myUser.reason ?? "Reason Not Specified",
                    textAlign: TextAlign.center,
                  ),
                  FlatButton(
                      color: Colors.deepPurple[500],
                      onPressed: () async {
                        fi
                            .collection("Admins")
                            .doc(myUser.uid)
                            .get()
                            .then((val) {
                          if (val.exists) {
                            myUser..name = val.data()["Name"];
                            myUser..reason = val.data()["reason"];
                            update(myUser);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Account Does Not Exist , Signing You Out",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER);
                            user.signOut();

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => RootPage()),
                                (route) => false);
                          }
                        }).catchError((onError) {
                          Fluttertoast.showToast(
                              msg: onError.toString(),
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER);
                        });
                      },
                      child: Text("Recheck Status")),
                  FlatButton(
                    color: Colors.red,
                    onPressed: () {
                      user.signOut();

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => RootPage()),
                          (route) => false);
                    },
                    child: Text(
                      "Log Out ",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
