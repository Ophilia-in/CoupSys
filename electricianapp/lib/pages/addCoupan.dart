import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electricianapp/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import '../services/constant.dart';

class AddCoupan extends StatefulWidget {
  AddCoupan({Key key}) : super(key: key);
  @override
  _AddCoupanState createState() => _AddCoupanState();
}

class _AddCoupanState extends State<AddCoupan> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("Coupans");
  DocumentSnapshot result;

  final User user = FirebaseAuth.instance.currentUser;
  String _coupan;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text("Add New Coupan"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Enter Coupan Code",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _coupan = value;
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.length < 6) return "Please Enter Valid Coupan code";
                  return null;
                },
                decoration: InputDecoration(
                    helperText: "Coupon Code",
                    hintText: "Type Here",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: MaterialButton(
                  color: Colors.green,
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Checking Code'),
                              CircularProgressIndicator()
                            ],
                          ),
                          content: Text(
                              'Dont Close the app , else you will not be able to use the code again'),
                        );
                      },
                    );

                    ref.doc(_coupan).get().then((value) {
                      if (!value.exists) {
                        Navigator.of(context).pop();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Invalid Code'),
                              content:
                                  Text('The Code You entered does not exist'),
                              actions: [
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        if (value.data()["usedBy"] == "") {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Code Found'),
                                content: Text('Fetching Points...'),
                              );
                            },
                          );
                          ref
                              .doc(_coupan)
                              .update({"usedBy": myUser.email}).catchError((e) {
                            Fluttertoast.showToast(
                                msg: "Error" + e.toString() + "Occurred");
                          }).whenComplete(() {
                            FirebaseFirestore.instance
                                .collection("transactions")
                                .add({
                              "coupancode": _coupan,
                              "receiverUid": myUser.uid,
                              "points": value.data()["points"],
                              "receiverPhone": myUser.phone,
                              "type": "Coupan",
                              "subType": "CREDIT",
                              "time": DateTime.now(),
                              "paid": true
                            }).then((newdoc) {
                              FirebaseFirestore.instance
                                  .collection("Member")
                                  .doc(myUser.uid)
                                  .collection("passbook")
                                  .doc(newdoc.id)
                                  .set({
                                "coupancode": _coupan,
                                "paid": true,
                                "receiverUid": myUser.uid,
                                "receiverPhone": myUser.phone,
                                "date": DateTime.now(),
                                "points": value.data()["points"],
                                "type": "Coupan",
                                "subType": "CREDIT"
                              }).whenComplete(() async {
                                Navigator.of(context).pop();
                                await FirebaseFirestore.instance
                                    .collection("Member")
                                    .doc(myUser.uid)
                                    .update({
                                  "points": FieldValue.increment(
                                      value.data()["points"])
                                });

                                myUser
                                  ..points =
                                      myUser.points + value.data()["points"];
                                _update(myUser);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Success'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              height: 100,
                                              width: 100,
                                              child: Lottie.asset(
                                                  "assets/tick.json")),
                                          Text('You Got ' +
                                              value
                                                  .data()["points"]
                                                  .toString() +
                                              ' points'),
                                        ],
                                      ),
                                      actions: [
                                        FlatButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            })
                                      ],
                                    );
                                  },
                                );
                              });
                            });
                          });
                        } else {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Code Already Used'),
                                content: Text(
                                    'The Code You entered is already used'),
                                actions: [
                                  FlatButton(
                                      child: Text("OK"),
                                      onPressed: () =>
                                          Navigator.of(context).pop())
                                ],
                              );
                            },
                          );
                        }
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ));
  }

  void _update(MyUser obj) async {
    await Hive.box<MyUser>(userBox).put("myuser", obj);
  }
}
