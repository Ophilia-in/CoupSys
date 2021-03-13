import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electricianapp/models/transactionModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

///This Function updates the phone number in the database.
Future<void> updatePhone(User user) async {
  await FirebaseFirestore.instance.collection('Member').doc(user.uid).update({
    'phone': user.phoneNumber,
  });
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
        dealerId: doc.data()['dealerId'],
        senderName: doc.data()['senderName'],
        recieverName: doc.data()['receiverName'],
        markedAsPaidAt: doc.data()["markedAsPaidAt"] == null
            ? null
            : doc.data()["markedAsPaidAt"].toDate());
  }).toList();
}
///Electrician doesnt needs to mark a payment as paid 

// Future<dynamic> markasPaid(TransactionRecord record) async {
//   try {
//     await FirebaseFirestore.instance
//         .collection("transactions")
//         .doc(record.transactionId)
//         .update({"paid": true});
//     await FirebaseFirestore.instance
//         .collection("Member")
//         .doc(record.senderUid)
//         .collection("passbook")
//         .doc(record.transactionId)
//         .update({"paid": true});

//     await FirebaseFirestore.instance
//         .collection("Member")
//         .doc(record.receiverUid)
//         .collection("passbook")
//         .doc(record.transactionId)
//         .update({"paid": true});
//     return true;
//   } catch (e) {
//     return e;
//   }
// }