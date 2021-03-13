import 'package:adminapp/models/individualTransaction.dart';
import 'package:adminapp/models/transactionModel.dart';
import 'package:adminapp/models/userModel.dart';
import 'package:adminapp/pages/dealerTransactionLogComplete.dart';
import 'package:adminapp/pages/transactionsComplete.dart';
import 'package:adminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../services/constant.dart';

class DealerTransactionLog extends StatefulWidget {
  DealerTransactionLog({Key key, this.uid}) : super(key: key);

  final String uid;
  @override
  _DealerTransactionLog createState() => _DealerTransactionLog();
}

class _DealerTransactionLog extends State<DealerTransactionLog> {
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
            .where("senderUid", isEqualTo: widget.uid)
            .orderBy('date', descending: true)
            .limit(10)
            .snapshots()
            .map(transactionRecordFromSnapshots),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
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
                                            DealerTransactionLogComplete(
                                              uid: widget.uid,
                                            )));
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
