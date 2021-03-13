import 'package:adminapp/models/individualTransaction.dart';
import 'package:adminapp/models/transactionModel.dart';
import 'package:adminapp/services/constant.dart';
import 'package:adminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DealerTransactionLogComplete extends StatefulWidget {
  DealerTransactionLogComplete({Key key, this.uid}) : super(key: key);

  final String uid;
  @override
  _DealerTransactionLogComplete createState() =>
      _DealerTransactionLogComplete();
}

class _DealerTransactionLogComplete
    extends State<DealerTransactionLogComplete> {
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
            .snapshots()
            .map(transactionRecordFromSnapshots),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
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
