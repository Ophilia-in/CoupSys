import 'package:adminapp/models/individualLog.dart';
import 'package:adminapp/models/logModel.dart';
import 'package:adminapp/models/userModel.dart';
import 'package:adminapp/services/constant.dart';
import 'package:adminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';


class LogsComplete extends StatelessWidget {
  final MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Logs"), backgroundColor: Colors.blue),
      body: StreamBuilder<List<Log>>(
        stream: FirebaseFirestore.instance
            .collection("transactions")
            .orderBy('time', descending: true)
            .snapshots()
            .map(logFromSnapshots),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return IndividualLog(
                        log: snapshot.data[index],
                      );
                    }));
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
