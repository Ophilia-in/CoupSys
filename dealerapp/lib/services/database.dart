import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dealerapp/models/transactionModel.dart';
import 'package:dealerapp/models/userModel.dart';
import 'package:dealerapp/services/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

Future<void> updatedata(MyUser user) async {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");

  if (myUser.points != user.points || myUser.earned != user.earned) {
    update(user);
  }
}

///This Function updates the phone number in the database.
Future<void> updatePhone(User user) async {
  await FirebaseFirestore.instance.collection('Member').doc(user.uid).update({
    'phone': user.phoneNumber,
  });
}

///This function checks whether anything has changed or not since the last update ,
/// runs once at Application Startup
Future<bool> hasChanged(String uid) async {
  final DocumentSnapshot result =
      await FirebaseFirestore.instance.collection('Member').doc(uid).get();

  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");
  if (myUser.points != result.data()["points"]) {
    await syncWithServer(uid);
    return true;
  } else
    return false;
}

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

///This functions syncs the changes in CLoud FireStore with the
///local Hive box [userBox] in this case
Future<void> syncWithServer(String uid) async {
  final DocumentSnapshot result =
      await FirebaseFirestore.instance.collection('Member').doc(uid).get();

  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");
  myUser
    ..points = result.data()["points"]
    ..earned = result.data()["earned"];
  update(myUser);
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
    );
  }).toList();
}

class UserService {
  final String uid;

  UserService(this.uid);

  final CollectionReference memberCollection =
      FirebaseFirestore.instance.collection("Member");

  Stream<MyUser> get userAccountData {
    return memberCollection.doc(this.uid).snapshots().map(maptouser);
  }

  MyUser maptouser(DocumentSnapshot result) {
    return MyUser(
        ids: result.data()["ids"] ?? null,
        dealerId: result.data()["dealerId"],
        reason: result.data()["reason"],
        name: result.data()["name"],
        photoUrl: result.data()['photoUrl'] ?? '',
        uid: result.data()['uid'],
        createdAt: result.data()['createdAt'].toDate(),
        email: result.data()["emailID"],
        points: result.data()["points"],
        phone: result.data()["phone"],
        earned: result.data()["earned"],
        accountType: result.data()["accountType"]);
  }
}
