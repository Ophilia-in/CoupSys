import 'package:adminapp/pages/logsComplete.dart';
import 'package:adminapp/models/individualLog.dart';
import 'package:adminapp/models/logModel.dart';
import 'package:adminapp/models/userModel.dart';
import 'package:adminapp/services/constant.dart';
import 'package:adminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class Logs extends StatefulWidget {
  Logs({Key key}) : super(key: key);

  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Logs"), backgroundColor: Colors.blue),
      body: StreamBuilder<List<Log>>(
        stream: FirebaseFirestore.instance
            .collection("transactions")
            .orderBy('time', descending: true)
            .limit(10)
            .snapshots()
            .map(logFromSnapshots),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: Scrollbar(
                  child: ListView.builder(
                      itemCount: snapshot.data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data.length) {
                          return ListTile(
                            title: Center(
                              child: TextButton(
                                child: Text("View ALL"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LogsComplete()));
                                },
                              ),
                            ),
                          );
                        }
                        return IndividualLog(
                          log: snapshot.data[index],
                        );
                      }),
                ));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Lottie.asset("assets/bulb.json"));
        },
      ),
    );
  }
}
