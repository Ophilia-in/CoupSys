import 'package:adminapp/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

const userBox = 'MyAdmin';

const couponurl =
    "https://script.google.com/macros/s/AKfycbw5daXD0y3mgOUWHe3_AWNYrkPb8o0Bht1NP2WKpLvDpkefU2jsQsE5r4y4bu6O72o9rw/exec";

const dbAdminUiD = " iwrCOg0zjAfC63WSckKZwv2xK0l2";

String jsonurl = "https://official-ophilia.github.io/coupons.json";
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
      await FirebaseFirestore.instance.collection('Admins').doc(user.uid).get();
  // Update data to server if new user
  if (!result.exists) {
    await Hive.box<MyUser>(userBox).put(
        "myuser",
        MyUser(
          reason: ".",
          uid: user.uid,
          createdAt: DateTime.now(),
          email: user.email,
          name: user.displayName ?? "Unknown",
        ));
  } else {
    await Hive.box<MyUser>(userBox).put(
        "myuser",
        MyUser(
          reason: result.data()["reason"] ?? '',
          name: result.data()["name"],
          uid: result.id,
          createdAt: result.data()['createdAt'].toDate(),
          email: result.data()["email"],
        ));
  }
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

void update(MyUser obj) async {
  await Hive.box<MyUser>(userBox).put("myuser", obj);
}
