import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electricianapp/Screens/screenDecider.dart';
import 'package:electricianapp/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import '../services/constant.dart';

class RedeemPoints extends StatefulWidget {
  RedeemPoints({Key key}) : super(key: key);

  @override
  _RedeemPointsState createState() => _RedeemPointsState();
}

class _RedeemPointsState extends State<RedeemPoints> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("Member");
  DocumentSnapshot dealerResult;
  final fi = FirebaseFirestore.instance;

  // bool _dealerInput = true;
  bool _pointsInput = true;
  bool _visible = false;
  String _redeeming = "";
  int _enteredpoints;
  String _dealerId;
  String _errorText;
  String _dealerErrorText;

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Redeem Points"),
          actions: [
            FlatButton(
              child: Text("View Points Chart"),
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    backgroundColor: Colors.blue,
                    context: context,
                    builder: (context) => Container(
                        padding: const EdgeInsets.all(10),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            "5 points Rs.5",
                            "20 points Rs.20",
                            "100 points Rs.100",
                            "500 points Rs.525",
                            "1000 points Rs.1050",
                            "2500 points Rs.2650",
                            "5000 points Rs.5400",
                            "10000 points Rs.11000",
                          ]
                              .map((e) => Text(
                                    e,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ))
                              .toList(),
                        )));
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: fi.collection("Member").doc(myUser.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (!snapshot.hasData)
              return Container(
                  height: _height,
                  alignment: Alignment.center,
                  child: Lottie.asset("assets/bulb.json"));
            else {
              if (snapshot.data.data()["points"] < 500) {
                myUser..points = snapshot.data.data()["points"];
                Fluttertoast.showToast(msg: "You have Insufficient Points");
                update(myUser);
                return Container(
                  child: ListView(
                    children: [
                      Lottie.asset("assets/sad2.json"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "You need ${500 - myUser.points} more points to redeem",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30),
                        ),
                      )
                    ],
                  ),
                );
              } else
                return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: ListView(
                      children: [
                        Container(
                          height: _height / 10,
                          margin: const EdgeInsets.only(top: 30, bottom: 50),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(color: Colors.black, width: 3)),
                          child: Center(
                            child: Text(
                                "Balance :  " +
                                    snapshot.data.data()["points"].toString() +
                                    " points ",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.teal)),
                          ),
                        ),
                        Text(
                          "Enter Amount of Points that you want to redeem",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          enabled: _pointsInput,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final temp = int.tryParse(value);
                            debugPrint(temp.toString());
                            if (temp == null) {
                              setState(() {
                                _errorText = "Not a Number";
                                _enteredpoints = 0;
                              });
                            } else if (temp < 100) {
                              setState(() {
                                _enteredpoints = temp;
                                _errorText = "Enter Greater than 100 ";
                              });
                            } else if (temp > snapshot.data.data()["points"]) {
                              setState(() {
                                _errorText = "You dont have this much points";
                                _enteredpoints = 0;
                              });
                            } else {
                              if (temp % 5 != 0) {
                                setState(() {
                                  _errorText = "Enter a multiple of 5";
                                  _enteredpoints = 0;
                                });
                              } else {
                                setState(() {
                                  _errorText = "";
                                  _enteredpoints = temp;
                                });
                              }
                            }
                          },
                          decoration: InputDecoration(
                              errorText: _errorText == "" ? null : _errorText,
                              counterText: _enteredpoints == null
                                  ? '0'
                                  : _enteredpoints.toString(),
                              labelText: "Points",
                              helperText: "Enter Points in multilple of 5",
                              hintText: "Type Here",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        Center(
                          child: MaterialButton(
                              color: Colors.green,
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              disabledColor: Colors.red,
                              onPressed: _enteredpoints != null
                                  ? (_enteredpoints > 100 &&
                                          _enteredpoints <
                                              snapshot.data.data()["points"])
                                      ? () {
                                          setState(() {
                                            _pointsInput = false;
                                            _visible = true;

                                            _redeeming = "Redeeming " +
                                                _enteredpoints.toString() +
                                                " points for Rs. " +
                                                calculate(_enteredpoints)
                                                    .toString();
                                          });
                                        }
                                      : null
                                  : null),
                        ),
                        _redeeming == ""
                            ? SizedBox(
                                height: 0,
                              )
                            : Text(_redeeming),
                        SizedBox(
                          height: _height / 20,
                        ),
                        _visible
                            ? Column(
                                children: [
                                  Text(
                                    "Enter Dealer Id",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextFormField(
                                    onChanged: (value) {
                                      if (value == null) {
                                        setState(() {
                                          _dealerErrorText = "Invalid";
                                          _dealerId = "";
                                        });
                                      } else if (value.length < 4) {
                                        setState(() {
                                          _dealerId = "";
                                          _dealerErrorText = "Too Short";
                                        });
                                      } else if (value.length > 10) {
                                        setState(() {
                                          _dealerErrorText = "Too Long";
                                          _dealerId = "";
                                        });
                                      } else {
                                        setState(() {
                                          _dealerErrorText = "";
                                          _dealerId = value;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        errorText: _dealerErrorText == ""
                                            ? null
                                            : _dealerErrorText,
                                        labelText: "Dealer Id",
                                        hintText: "Type Here",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                  Center(
                                    child: FlatButton(
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      color: Colors.green,
                                      disabledColor: Colors.red,
                                      onPressed: (_dealerId != null &&
                                              _dealerId.length > 4 &&
                                              _dealerId.length < 10)
                                          ? () async {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            'Checking Dealer Id'),
                                                        CircularProgressIndicator()
                                                      ],
                                                    ),
                                                    content: Text(
                                                        'Dont Close the app , else you will loose the points'),
                                                  );
                                                },
                                              );
                                              dealerResult = await fi
                                                  .collection("dealers")
                                                  .doc(_dealerId)
                                                  .get();

                                              if (!dealerResult.exists) {
                                                //Not Found
                                                Navigator.of(context).pop();

                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Invalid Dealer Id'),
                                                      content: Text(
                                                          'Dealer does not exist'),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text("OK"),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                Navigator.of(context).pop();
                                                //Shown so that user can wait
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Dealer Found'),
                                                          CircularProgressIndicator()
                                                        ],
                                                      ),
                                                      content:
                                                          Text('Processing'),
                                                    );
                                                  },
                                                );

                                                ref
                                                    .doc(dealerResult
                                                        .data()["uid"])
                                                    .update({
                                                  "points":
                                                      FieldValue.increment(
                                                          _enteredpoints)
                                                }).whenComplete(() async {
                                                  myUser
                                                    ..points = myUser.points -
                                                        _enteredpoints;
                                                  myUser
                                                    ..earned = myUser.earned +
                                                        calculate(
                                                            _enteredpoints);
                                                  _update(myUser);
                                                  await ref
                                                      .doc(myUser.uid)
                                                      .update({
                                                    "earned": FieldValue
                                                        .increment(calculate(
                                                            _enteredpoints)),
                                                    "points":
                                                        FieldValue.increment(
                                                            -_enteredpoints)
                                                  });
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          "transactions")
                                                      .add({
                                                    "type": "Redeem",
                                                    "subType": "DEBIT",
                                                    "amount": calculate(
                                                        _enteredpoints),
                                                    "senderPhone":
                                                        myUser.phone.toString(),
                                                    "senderUid": myUser.uid,
                                                    "receiverPhone":
                                                        dealerResult
                                                            .data()["phone"],
                                                    "dealerId": dealerResult
                                                        .data()["dealerId"],
                                                    "receiverUid": dealerResult
                                                        .data()["uid"],
                                                    "points": _enteredpoints,
                                                    "time": DateTime.now()
                                                  }).then((newdoc) async {
                                                    await ref
                                                        .doc(dealerResult
                                                            .data()["uid"])
                                                        .collection("passbook")
                                                        .doc(newdoc.id)
                                                        .set({
                                                      "senderPhone":
                                                          myUser.phone,
                                                      "receiverPhone":
                                                          dealerResult
                                                              .data()["phone"],
                                                      "senderUid": myUser.uid,
                                                      "receiverUid":
                                                          dealerResult
                                                              .data()["uid"],
                                                      "date": DateTime.now(),
                                                      "points": _enteredpoints,
                                                      "type": "Redeem",
                                                      "amount": calculate(
                                                          _enteredpoints),
                                                      "subType": "CREDIT",
                                                    });
                                                    await ref
                                                        .doc(myUser.uid)
                                                        .collection("passbook")
                                                        .doc(newdoc.id)
                                                        .set({
                                                      "dealerId": _dealerId,
                                                      "date": DateTime.now(),
                                                      "senderPhone":
                                                          myUser.phone,
                                                      "points": -_enteredpoints,
                                                      "senderUid": myUser.uid,
                                                      "receiverUid":
                                                          dealerResult
                                                              .data()["uid"],
                                                      "receiverPhone":
                                                          dealerResult
                                                              .data()["phone"],
                                                      "amount": calculate(
                                                          _enteredpoints),
                                                      "type": "Redeem",
                                                      "subType": "DEBIT",
                                                    });
                                                  });
                                                }).whenComplete(() {
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text('Success'),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                                height: 100,
                                                                width: 100,
                                                                child: Lottie.asset(
                                                                    "assets/tick.json")),
                                                            Text('You Redeemed ' +
                                                                _enteredpoints
                                                                    .toString() +
                                                                '  points for Rs.${calculate(_enteredpoints)}'),
                                                          ],
                                                        ),
                                                        actions: [
                                                          FlatButton(
                                                              child: Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.pop(
                                                                    context);
                                                              })
                                                        ],
                                                      );
                                                    },
                                                  );
                                                });
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                height: 0,
                              )
                      ],
                    ));
            }
          },
        ));
  }

  void _update(MyUser obj) async {
    await Hive.box<MyUser>(userBox).put("myuser", obj);
  }
}
