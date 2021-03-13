import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dealerapp/login/rootPage.dart';
import 'package:dealerapp/login/userProvider.dart';
import 'package:dealerapp/models/userModel.dart';
import 'package:dealerapp/services/constant.dart';
import 'package:dealerapp/services/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:carousel_slider/carousel_slider.dart';

class NotAllowed extends StatefulWidget {
  @override
  _NotAllowedState createState() => _NotAllowedState();
}

class _NotAllowedState extends State<NotAllowed> {
  final inst = FirebaseAuth.instance;

  final fi = FirebaseFirestore.instance;

  var myFuture;

  @override
  void initState() {
    // TODO: implement a new Way for getting this future
    myFuture = fetchForHomePage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Waiting For Access")),
          backgroundColor: Color(0xff0066cc),
          actions: [
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
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        body: FutureBuilder<List>(
            future: myFuture,
            builder: (context, snapshot) {
              return ValueListenableBuilder(
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
                          "Welcome!!",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(color: Colors.grey[200])),
                        ),
                        Text(
                          myUser.reason ?? "Reason Not Specified",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        FlatButton(
                            color: Color(0xff93ea2e),
                            onPressed: () async {
                              fi
                                  .collection("Member")
                                  .doc(myUser.uid)
                                  .get()
                                  .then((val) {
                                myUser..ids = val.data()["ids"];
                                myUser..accountType = val.data()["accountType"];
                                myUser..dealerId = val.data()["dealerId"];
                                myUser..reason = val.data()["reason"];
                                myUser..phone = val.data()["phone"];
                                print(myUser.uid);
                                update(myUser);
                              });
                            },
                            child: Text("Recheck Status")),
                        if (!snapshot.hasError)
                          if (!snapshot.hasData)
                            Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.green,
                            ))
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Color(0xff0066cc),
                                  borderRadius: BorderRadius.circular(20)),
                              child: CarouselSlider(
                                items: snapshot.data,
                                options: CarouselOptions(
                                  initialPage: 0,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  aspectRatio: 2.0,
                                ),
                              ),
                            )
                        else
                          Center(child: Text(snapshot.error.toString()))
                      ],
                    );
                  });
            }));
  }
}

void update(MyUser obj) async {
  await Hive.box<MyUser>(userBox).put("myuser", obj);
}
