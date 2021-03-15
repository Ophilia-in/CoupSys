import 'dart:convert' as convert;
import 'dart:ui';

import 'package:adminapp/services/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class AddCoupans extends StatefulWidget {
  AddCoupans({Key key}) : super(key: key);

  @override
  _AddCoupansState createState() => _AddCoupansState();
}

class _AddCoupansState extends State<AddCoupans> {
  bool _isbusy = false;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Coupans"),
          backgroundColor: Colors.blue,
        ),
        bottomNavigationBar: FlatButton(
            height: 50,
            color: Colors.green,
            onPressed: () {
              Clipboard.setData(new ClipboardData(
                      text:
                         sheetsURl))
                  .then((value) {
                Fluttertoast.showToast(msg: "Copied Link to Clipboard");
              }).catchError((onError) {
                Fluttertoast.showToast(msg: "Failed to Copy Link to Clipboard");
              });
            },
            child: Text("Tap to Copy sheets Link ")),
        body: Stack(
          children: [
            _isbusy
                ? Container(
                    color: Colors.grey,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: _height * 0.03,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Text(
                              "1.",
                              style: TextStyle(fontSize: 20),
                            ),
                            title: Text(
                              "Clear the google sheet.",
                              style: GoogleFonts.lato(
                                  // textStyle:
                                  ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              "2.",
                              style: TextStyle(fontSize: 20),
                            ),
                            title: Text(
                              "Upload the New Coupans in the Google Sheets Provided\n",
                              style: GoogleFonts.lato(
                                  // textStyle:
                                  ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              "3.",
                              style: TextStyle(fontSize: 20),
                            ),
                            title: Text(
                              "Click Add button below to upload the coupons in database",
                              style: GoogleFonts.lato(
                                  // textStyle:
                                  ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                    mybutton(context)
                  ],
                )),
          ],
        ));
  }

  mybutton(BuildContext cont) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              child: Text("Add"),
              onPressed: () async {
                // BuildContext dialogcontext;
                showDialog(
                    context: cont,
                    builder: (cont) {
                      // dialogcontext = context;
                      return AlertDialog(
                        title: Text("Confirm"),
                        content: Text("Are you Sure You Want to Add Coupans"),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(cont).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text("No")),
                          FlatButton(
                              onPressed: () async {
                                Navigator.pop(cont);
                                addcoupon(context);
                              },
                              child: Text("Yes"))
                        ],
                      );
                    });
              },
              color: Colors.cyan),
        ],
      ),
    );
  }

  addcoupon(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection("Coupans");
    showDialog(
        barrierColor: Colors.white10,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 12),
            children: [
              Column(
                // mainAxisAlignment: MainA
                children: [
                  Text(
                    "Adding ... ",
                    style: TextStyle(fontSize: 20),
                  ),
                  LinearProgressIndicator(),
                ],
              )
            ],
          );
        });

    fetchData().then((value) async {
      value.forEach((element) async {
        await ref.doc(element.id).set({
          "points": int.parse(element.points),
          "usedBy": ""
        }).catchError((onError) {
          Fluttertoast.showToast(msg: "Some Error Occurred");
        });
      });
      Navigator.of(context).pop();
      showDialog(
          barrierColor: Colors.white10,
          context: context,
          builder: (context) {
            return SimpleDialog(
              children: [
                Center(
                  child: Text("Successfully Added  ${value.length} Coupans "),
                )
              ],
            );
          });
    }).catchError((onError) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: onError.toString());
    });
  }
}

Future<List<Coupan>> fetchData() async {
  final response = await http.get(
     Uri.parse(couponurl));
  if (response.statusCode == 200) {
    var data = convert.jsonDecode(response.body) as List;
    return data.map((json) => Coupan.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load');
  }
}

class Coupan {
  String id;
  String points;
  Coupan(this.id, this.points);

  factory Coupan.fromJson(dynamic json) {
    return Coupan("${json['id']}", "${json['points']}");
  }
}
