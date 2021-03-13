import 'package:adminapp/models/dealerModel.dart';
import 'package:adminapp/models/logModel.dart';
import 'package:adminapp/models/transactionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///This Function Marks A individual Tranasaction as Paid
///Takes the transaction Record as a parameter .
Future<dynamic> markasPaid(TransactionRecord record) async {
  try {
    await FirebaseFirestore.instance
        .collection("transactions")
        .doc(record.transactionId)
        .update({"paid": true});
    await FirebaseFirestore.instance
        .collection("Member")
        .doc(record.senderUid)
        .collection("passbook")
        .doc(record.transactionId)
        .update({"paid": true});

    await FirebaseFirestore.instance
        .collection("Member")
        .doc(record.receiverUid)
        .collection("passbook")
        .doc(record.transactionId)
        .update({"paid": true});
    return true;
  } catch (e) {
    return e;
  }
}

///This Function Marks A individual Tranasaction as Paid
///Takes the transaction Record as a parameter .
Future<dynamic> markTransactionasPaid(Log record) async {
  try {
    await FirebaseFirestore.instance
        .collection("transactions")
        .doc(record.transactionId)
        .update({"paid": true});
    await FirebaseFirestore.instance
        .collection("Member")
        .doc(record.senderUid)
        .collection("passbook")
        .doc(record.transactionId)
        .update({"paid": true});

    await FirebaseFirestore.instance
        .collection("Member")
        .doc(record.receiverUid)
        .collection("passbook")
        .doc(record.transactionId)
        .update({"paid": true});
    return true;
  } catch (e) {
    return e;
  }
}

List<TransactionRecord> transactionRecordFromSnapshots(QuerySnapshot snapshot) {
  print("stream called");
  return snapshot.docs.map((doc) {
    return TransactionRecord(
      paid: doc.data()["paid"] ?? false,
      transactionId: doc.id,
      senderUid: doc.data()["senderUid"],
      receiverUid: doc.data()["receiverUid"],
      type: doc.data()['type'],
      amount: doc.data()['amount'],
      subType: doc.data()['subType'],
      senderPhone: doc.data()['senderPhone'] ?? "Not Available",
      receiverPhone: doc.data()['receiverPhone'] ?? "Not Available",
      points: doc.data()['points'],
      date: doc.data()['date'].toDate(),
      coupancode: doc.data()['coupancode'],
      dealerId: doc.data()['dealerId']??"Not Available",
    );
  }).toList();
}

List<Log> logFromSnapshots(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Log(
      paid: doc.data()["paid"] ?? false,
      transactionId: doc.id,
      senderUid: doc.data()["senderUid"]??"Not Available",
      receiverUid: doc.data()["receiverUid"]??"Not Available",
      type: doc.data()['type'],
      amount: doc.data()['amount']??0,
      subType: doc.data()['subType'],
      senderPhone: doc.data()['senderPhone'] ?? "Not Available",
      receiverPhone: doc.data()['receiverPhone'] ?? "Not Available",
      points: doc.data()['points'],
      date: doc.data()['time'].toDate(),
      coupancode: doc.data()['coupancode'],
      dealerId: doc.data()['dealerId'],
    );
  }).toList();
}

List<Dealer> dealerfromSnapshots(QuerySnapshot snapshot) {
  return snapshot.docs.map((e) {
    return Dealer(
        name: e.data()["name"]??"",
        ids: e.data()["ids"] ?? List(), 
        dealerId: e.data()["dealerId"]??null,
        reason: e.data()["reason"]??"",
        photoUrl: e.data()['photoUrl'] ?? '',
        uid: e.data()['uid']??"",
        createdAt: e.data()['createdAt'].toDate(),
        email: e.data()["emailID"]??"",
        points: e.data()["points"]??"",
        phone: e.data()["phone"]??null,
        earned: e.data()["earned"]??"",
        accountType: e.data()["accountType"],
        firmName: e.data()["firmName"]);
  }).toList();
}

//Hz09208
