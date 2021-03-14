import 'package:adminapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'logModel.dart';
import 'package:intl/intl.dart';

class IndividualLog extends StatelessWidget {
  final Log log;

  const IndividualLog({Key key, this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
          color: log.paid ? Colors.green : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: log.type == "Coupan" ? credit(log) : redeemed(log)),
    );
  }
}

credit(Log log) {
  return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Coupan Code : " + log.coupancode),
        Text(
          "Reciever Phone : " + log.receiverPhone.toString(),
          textAlign: TextAlign.left,
        ),
        Text("Reciever Name : " + log.recieverName),
        Text("Transaction Id : " + log.transactionId),
        FlatButton(
            disabledColor: Colors.green,
            color: Colors.blue,
            onPressed: log.paid
                ? null
                : () async {
                    await markTransactionasPaid(log).then((value) {
                      if (value == true) {
                        Fluttertoast.showToast(msg: "Marked As Paid");
                      } else {
                        Fluttertoast.showToast(msg: value.toString());
                      }
                    });
                  },
            child: Center(
                child: Text(
              log.paid ? "Credited" : "Mark As Credited",
              style: TextStyle(color: Colors.white),
            )))
      ],
      leading: Text(log.type.toString(),
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Color(0xff000666), fontWeight: FontWeight.bold)),
      title: Text(
        log.points.toString() + " Points",
        style: TextStyle(color: log.paid ? Colors.white : Colors.blue[900]),
      ),
      trailing: Text(DateFormat('dd MMM y kk:mm').format(log.date)));
}

redeemed(Log log) {
  return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (log.recieverName == "Admin" || log.recieverName == '"Admin"')
            ? Center(child: Text("Dealer Redeem" , style: TextStyle(fontWeight: FontWeight.bold),))
            : Center(
                child: Text("Electrician Redeem",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
        Text("Dealer Id : " + log.dealerId.toString()),
        Text("Receiver Phone : " + log.receiverPhone),
        Text("Sender Phone : " + log.senderPhone),
        Text("Reciever Name : " + log.recieverName),
        Text("Sender Name : " + log.senderName),
        Text("Transaction Id : " + log.transactionId),
        log.markedAsPaidAt != null
            ? Text("Paid at : " + DateFormat('dd MMM y kk:mm').format(log.date))
            : Text("Paid At : " + "Not yet Paid"),
        FlatButton(
            disabledColor: Colors.green,
            color: Colors.blue,
            onPressed: (log.paid == false &&
                    (log.recieverName == "Admin" ||
                        log.recieverName == '"Admin"'))
                ? () async {
                    await markTransactionasPaid(log).then((value) {
                      if (value == true) {
                        Fluttertoast.showToast(msg: "Marked As Paid");
                      } else {
                        Fluttertoast.showToast(msg: value.toString());
                      }
                    });
                  }
                : null,
            child: Center(
                child: Text(
              (log.paid == true)
                  ? "Paid"
                  : (log.recieverName == "Admin" ||
                          log.recieverName == '"Admin"')
                      ? "Mark As Paid"
                      : "You cant Mark it as Paid",
              style: TextStyle(color: Colors.white),
            )))
      ],
      leading: Text(log.type.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      title: Text(
        log.points.toString() +
            " Points for Rs." +
            log.amount
                // (-1 * calculate(log.points))
                .toString(),
        style: TextStyle(color: log.paid ? Colors.white : Colors.blue[900]),
      ),
      trailing: Text(DateFormat('dd MMM y kk:mm').format(log.date)));
}
