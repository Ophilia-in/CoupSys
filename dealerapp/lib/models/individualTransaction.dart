import 'package:dealerapp/models/transactionModel.dart';
import 'package:dealerapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class IndividualTransactionRecord extends StatelessWidget {
  final TransactionRecord transactionRecord;

  const IndividualTransactionRecord({Key key, this.transactionRecord})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
          color: transactionRecord.paid ? Colors.green : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: transactionRecord.subType == "CREDIT"
              ? credit(transactionRecord)
              : redeemed(transactionRecord)),
    );
  }
}

credit(TransactionRecord transactionRecord) {
  return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sender Phone : " + transactionRecord.senderPhone.toString(),
          textAlign: TextAlign.left,
        ),
        Text("Receiver Phone : " + transactionRecord.receiverPhone),
        Text("Transaction Id : " + transactionRecord.transactionId),
        Text("Sender Name : " + transactionRecord.senderName),
        transactionRecord.markedAsPaidAt != null
            ? Text("Paid at : " +
                DateFormat('dd MMM y kk:mm').format(transactionRecord.date))
            : Text("Paid At : " + "Not yet Paid"),
        FlatButton(
            disabledColor: Colors.green,
            color: Colors.blue,
            onPressed: transactionRecord.paid
                ? null
                : () async {
                    await markasPaid(transactionRecord).then((value) {
                      if (value == true) {
                        Fluttertoast.showToast(msg: "Marked As Paid");
                      } else {
                        Fluttertoast.showToast(msg: value.toString());
                      }
                    });
                  },
            child: Center(
                child: Text(
              transactionRecord.paid ? "Paid" : "Mark As Paid",
              style: TextStyle(color: Colors.white),
            )))
      ],
      leading: Text(transactionRecord.subType.toString(),
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Color(0xff000666), fontWeight: FontWeight.bold)),
      title: Text(
        transactionRecord.points.toString() +
            " Points for Rs." +
            transactionRecord.amount.toString(),
        style: TextStyle(
            color: transactionRecord.paid ? Colors.white : Colors.blue[900]),
      ),
      trailing:
          Text(DateFormat('dd MMM y kk:mm').format(transactionRecord.date)));
}

redeemed(TransactionRecord transactionRecord) {
  transactionRecord.markedAsPaidAt!=null?print(""):print("null");
  return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dealer Id : " + transactionRecord.dealerId.toString(),
          textAlign: TextAlign.left,
        ),
        Text("Dealer Phone : " + transactionRecord.receiverPhone),
        Text("Sender Phone : " + transactionRecord.senderPhone),
        Text("Transaction Id : " + transactionRecord.transactionId),
        Text("Sender Name : " + transactionRecord.senderName),
        transactionRecord.markedAsPaidAt != null
            ? Text("Received at : " +
               DateFormat('dd MMM y kk:mm').format(transactionRecord.markedAsPaidAt))
            : Text("Received At : " + "Not yet Received"),
        FlatButton(
            disabledColor: Colors.green,
            color: Colors.blue,
            onPressed:
                // transactionRecord.paid
                //     ?
                null,
            // : () async {
            //     await markasPaid(transactionRecord).then((value) {
            //       if (value == true) {
            //         Fluttertoast.showToast(msg: "Marked As Received");
            //       } else {
            //         Fluttertoast.showToast(msg: value.toString());
            //       }
            //     });
            //   },
            child: Center(
                child: Text(
              transactionRecord.paid ? "Received" : "Collect Cash From Company",
              style: TextStyle(color: Colors.white),
            )))
      ],
      leading: Text(transactionRecord.subType.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      title: Text(
        transactionRecord.points.toString() +
            " Points for Rs." +
            transactionRecord.amount
                // (-1 * calculate(transactionRecord.points))
                .toString(),
        style: TextStyle(
            color: transactionRecord.paid ? Colors.white : Colors.blue[900]),
      ),
      trailing:
          Text(DateFormat('dd MMM y kk:mm').format(transactionRecord.date)));
}
