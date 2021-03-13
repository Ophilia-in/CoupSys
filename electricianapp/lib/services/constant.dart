import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electricianapp/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

const userBox = 'MyUser';

List<int> slots = [100, 500, 1000, 2500, 5000, 10000, 50000];

String jsonurl = "https://ophilia-in.github.io/coupons.json";

// "https://raw.githubusercontent.com/Official-Ophilia/Official-Ophilia.github.io/master/coupons.json";
TextStyle sheettext = TextStyle(fontSize: 17, fontWeight: FontWeight.w400);

int calculate(int points) {
  int mul, amt = 0;
  while (points > 0) {
    if (points >= 10000) {
      mul = (points ~/ 10000);
      amt += (mul * 11000);
      points = points % 10000;
    } else if (points >= 5000) {
      mul = (points ~/ 5000);
      amt += (mul * 5400);
      points = points % 5000;
    } else if (points >= 2500) {
      mul = points ~/ 2500;
      amt += (mul * 2650);
      points = points % 2500;
    } else if (points >= 1000) {
      mul = points ~/ 1000;
      amt += (mul * 1050);
      points = points % 1000;
    } else if (points >= 500) {
      mul = points ~/ 500;
      amt += (mul * 525);
      points = points % 500;
    } else {
      amt += points;
      points = 0;
    }
  }
  return amt;
}

Future<void> loginCallback() async {
  if (!Hive.box<MyUser>(userBox).isOpen || !await Hive.boxExists(userBox)) {
    await Hive.openBox<MyUser>(userBox);
  }
  final user = FirebaseAuth.instance.currentUser;
  final DocumentSnapshot result =
      await FirebaseFirestore.instance.collection('Member').doc(user.uid).get();
  // Update data to server if new user
  if (!result.exists) {
    await FirebaseFirestore.instance.collection('Member').doc(user.uid).set({
      'name': user.displayName,
      'photoUrl': user.photoURL.isNotEmpty ? user.photoURL : "",
      'uid': user.uid,
      'createdAt': DateTime.now(),
      'emailID': user.email,
      'accountType': "Customer",
      'points': 0,
      'phone': user.phoneNumber,
      'earned': 0,
    });
    await Hive.box<MyUser>(userBox).put(
        "myuser",
        MyUser(
            photoUrl: user.photoURL.isNotEmpty ? user.photoURL : "",
            uid: user.uid,
            accountType: "Customer",
            createdAt: DateTime.now(),
            points: 0,
            email: user.email,
            phone: user.phoneNumber,
            name: user.displayName,
            earned: 0));
  } else {
    await Hive.box<MyUser>(userBox).put(
        "myuser",
        MyUser(
            name: result.data()["name"],
            photoUrl: result.data()['photoUrl'] ?? '',
            uid: result.data()['uid'],
            createdAt: result.data()['createdAt'].toDate(),
            email: result.data()["emailID"],
            points: result.data()["points"],
            phone: result.data()["phone"],
            earned: result.data()["earned"],
            accountType: result.data()["accountType"]));
  }

  // return Future.delayed(Duration.zero);
}

Widget buildWaitingScreen(BuildContext context) {
  return Scaffold(
    body: Container(
        // color: Colors.green,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Lottie.asset("assets/bulb.json")),
  );
}
