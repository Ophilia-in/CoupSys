import 'package:adminapp/models/logModel.dart';
import 'package:adminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class ExportAllTransaction extends StatefulWidget {
  ExportAllTransaction({Key key}) : super(key: key);

  @override
  _ExportAllTransactionState createState() => _ExportAllTransactionState();
}

class _ExportAllTransactionState extends State<ExportAllTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Export All Transactions Except Coupan Redeem "),
      ),
      body: StreamBuilder<List<Log>>(
        stream: FirebaseFirestore.instance
            .collection("transactions")
            .orderBy('time', descending: true)
            .snapshots()
            .map(logFromSnapshots),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: Center(
              child: TextButton(
                child: Text("Export"),
                onPressed: () async {
                  showAlertDialog(context);
                  var excel = Excel.createExcel();
                  var sheet = excel['Sheet1'];
                  sheet.appendRow([
                    "Sender Phone",
                    "Reciever Phone ",
                    "Sender Name",
                    "Reciever Name ",
                    "Transaction Id",
                    "Amount",
                    "Paid",
                    "Marked As Paid At",
                    "Points",
                    "Transaction Time"
                  ]);
                  for (int i = 0; i < snapshot.data.length; i++) {
                    if(snapshot.data[i].type=="Redeem")sheet.appendRow([
                      snapshot.data[i].senderPhone,
                      snapshot.data[i].receiverPhone,
                      snapshot.data[i].senderName,
                      snapshot.data[i].recieverName ?? "Not Avaialble",
                      snapshot.data[i].transactionId,
                      snapshot.data[i].amount,
                      snapshot.data[i].paid?"Yes":"No",
                      snapshot.data[i].markedAsPaidAt != null
                          ? DateFormat('dd MMM y kk:mm')
                              .format(snapshot.data[i].markedAsPaidAt)
                          : "Not Yet Paid",
                      snapshot.data[i].points,
                      DateFormat('dd MMM y kk:mm').format(snapshot.data[i].date)
                    ]);
                  }
                  await excel.save(fileName: "All Transactions.xlsx");

                  Navigator.pop(context);
                },
              ),
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

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("Generating Excel File , Please Be Patient"),
  );
  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
