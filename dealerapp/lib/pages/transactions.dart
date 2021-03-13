import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dealerapp/models/individualTransaction.dart';
import 'package:dealerapp/models/transactionModel.dart';
import 'package:dealerapp/models/userModel.dart';
import 'package:dealerapp/pages/transactionsComplete.dart';
import 'package:dealerapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import '../services/constant.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");

  // User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0066cc),
      // Colors.cyan,
      body: StreamBuilder<List<TransactionRecord>>(
        stream: FirebaseFirestore.instance
            .collection("Member")
            .doc(myUser.uid)
            .collection("passbook")
            .orderBy('date', descending: true)
            .limit(10)
            .snapshots()
            .map(transactionRecordFromSnapshots),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(child: Text("No Transactions yet"));
            } else
              return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.blue,
                    Colors.blue,
                    // Color(0xff0066cc),
                    // Colors.cyan,
                    Colors.white
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                  child: ListView.builder(
                      itemCount: snapshot.data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data.length) {
                          return ListTile(
                            title: Center(
                              child: TextButton(
                                child: Text(
                                  "View ALL",
                                  style: TextStyle(color: Color(0xff000666)),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionComplete()));
                                },
                              ),
                            ),
                          );
                        }
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
