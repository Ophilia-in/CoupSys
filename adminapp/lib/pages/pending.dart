import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adminapp/models/individualTransaction.dart';
import 'package:adminapp/models/userModel.dart';
import 'package:adminapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:adminapp/models/transactionModel.dart';
import 'package:lottie/lottie.dart';

import '../services/constant.dart';

class PendingTransactionsComplete extends StatefulWidget {
  PendingTransactionsComplete({Key key}) : super(key: key);

  @override
  _PendingTransactionsCompleteState createState() =>
      _PendingTransactionsCompleteState();
}

class _PendingTransactionsCompleteState
    extends State<PendingTransactionsComplete> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");

  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "All Pending Transactions",
            ),
            backgroundColor: Colors.blue),
        body: myStreamBuilder());
  }

  myStreamBuilder() {
    return StreamBuilder<List<TransactionRecord>>(
      stream: FirebaseFirestore.instance
          .collection("Member")
          .doc(dbAdminUiD)
          .collection("passbook")
          .where("paid", isEqualTo: false)
          .orderBy('date', descending: true)
          .snapshots()
          .map(transactionRecordFromSnapshots),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text("Awsome!! No Pending Transactions"),
            );  
          }
          return Container(
              child: Scrollbar(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return IndividualTransactionRecord(
                        transactionRecord: snapshot.data[index],
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
    );
  }
}
