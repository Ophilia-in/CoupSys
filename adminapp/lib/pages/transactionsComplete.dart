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

class TransactionComplete extends StatefulWidget {
  TransactionComplete({Key key}) : super(key: key);

  @override
  _TransactionCompleteState createState() => _TransactionCompleteState();
}

class _TransactionCompleteState extends State<TransactionComplete> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");

  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "All Transactions",
          ),
          backgroundColor: Colors.blue),
      body: StreamBuilder<List<TransactionRecord>>(
        stream: FirebaseFirestore.instance
            .collection("Member")
            .doc(dbAdminUiD)
            .collection("passbook")
            .orderBy('date', descending: true)
            .snapshots()
            .map(transactionRecordFromSnapshots),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                color: Colors.blue,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return IndividualTransactionRecord(
                        transactionRecord: snapshot.data[index],
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
