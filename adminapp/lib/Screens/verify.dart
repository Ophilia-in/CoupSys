import 'package:adminapp/Screens/mainScreen.dart';
import 'package:adminapp/rest/ids.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Verify extends StatefulWidget {
  Verify({Key key}) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Member")
            .where("dealerId", isEqualTo: "")
            .get(GetOptions(source: Source.serverAndCache)),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString() + "has Occurred"),
            );
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.data.docs.length == 0) {
                  return Center(child: Text("No New Applications"));
                } else
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data.docs[index];
                        return ListTile(
                          title: Text(data.data()["phone"] == null
                              ? "Still on Phone Verification Page"
                              : (data.data()["ids"] == null ||
                                      data.data()["ids"].length < 3)
                                  ? "On registration Page"
                                  : data.data()["phone"].toString()),
                          subtitle: Text(data.data()["name"]),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => IndividualVerify(
                                          data: data,
                                        )));
                          },
                        );
                      });
                break;

              case ConnectionState.active:
                return Text("Connection Active");
                break;
              case ConnectionState.waiting:
                return Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: Lottie.asset("assets/bulb.json"));
                break;
              case ConnectionState.none:
                return Text("Nothing Happening , is Your Internet Working ?");
                break;
              default:
                return Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: Lottie.asset("assets/bulb.json"));
            }
          }
        },
      ),
    );
  }
}

class IndividualVerify extends StatefulWidget {
  const IndividualVerify({Key key, this.data}) : super(key: key);

  final DocumentSnapshot data;

  @override
  _IndividualVerifyState createState() => _IndividualVerifyState();
}

class _IndividualVerifyState extends State<IndividualVerify> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width * 0.75;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.data.data()["phone"] ?? "Not Yet Added"),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 50,
              child: FlatButton(
                onPressed: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (ctxt) {
                        return AlertDialog(
                          content: Text("Processing"),
                        );
                      });
                  FirebaseFirestore.instance
                      .collection("dealers")
                      .doc(widget.data.data()["uid"].substring(0, 3) +
                          widget.data
                              .data()["phone"]
                              .toString()
                              .substring(3, 7))
                      .set({
                    "uid": widget.data.data()["uid"],
                    "dealerId": widget.data.data()["uid"].substring(0, 3) +
                        widget.data.data()["phone"].toString().substring(3, 7),
                    "phone": widget.data.data()["phone"]
                  }).whenComplete(() {
                    FirebaseFirestore.instance
                        .collection("Member")
                        .doc(widget.data.data()["uid"])
                        .update({
                      "dealerId": widget.data.data()["uid"].substring(0, 3) +
                          widget.data.data()["phone"].toString().substring(3, 7)
                    }).whenComplete(() {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen()),
                                          (route) => false);
                                    },
                                    child: Text("Okay"))
                              ],
                              title: Text("Success"),
                              content: Text("Assigned Dealer ID : " +
                                  widget.data.data()["uid"].substring(0, 3) +
                                  widget.data
                                      .data()["phone"]
                                      .toString()
                                      .substring(3, 7)),
                            );
                          });
                    });
                  }).catchError((onError) {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Ok"))
                            ],
                            title: Text("Error Occurred"),
                            content: Text(onError.toString()),
                          );
                        });
                  });
                },
                child: Text("Approve"),
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 50,
              child: FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctxt) {
                        return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Enter Reason"),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      hintText: "Reason",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  controller: _controller,
                                )
                              ],
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(ctxt);
                                    showDialog(
                                        context: ctxt,
                                        builder: (ct) {
                                          return SimpleDialog(
                                            children: [
                                              Text("Processing .... "),
                                              LinearProgressIndicator()
                                            ],
                                          );
                                        });
                                    print(widget.data.data()["uid"]);
                                    FirebaseFirestore.instance
                                        .collection("Member")
                                        .doc(widget.data.data()["uid"])
                                        .update({
                                      "dealerId": "None",
                                      "reason":
                                          _controller.text ?? "Not Specified"
                                    }).then((value) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }).catchError((onError) {
                                      Navigator.pop(context);
                                      showDialog(
                                          context: context,
                                          builder: (ct) {
                                            return AlertDialog(
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(ct);
                                                    },
                                                    child: Text("Ok"))
                                              ],
                                              title: Text("Error Occurred"),
                                              content: Text(onError.toString()),
                                            );
                                          });
                                    });
                                  },
                                  child: Text("Reject"))
                            ]);
                      });
                },
                child: Text("Reject"),
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: widget.data.data()["photoUrl"],
                ),
              ),
              ListTile(
                title: Text("Name"),
                subtitle: Text(widget.data.data()["name"]),
              ),
              ListTile(
                title: Text("Uid"),
                subtitle: Text(widget.data.data()["uid"]),
              ),
              ListTile(
                title: Text("Account Type"),
                subtitle: Text(widget.data.data()["accountType"]),
              ),
              ListTile(
                title: Text("Email"),
                subtitle: Text(widget.data.data()["emailID"]),
              ),
              ListTile(
                title: Text("Created At"),
                subtitle: Text(DateFormat('dd MMM y kk:mm')
                    .format(widget.data.data()["createdAt"].toDate())),
              ),
              ListTile(
                  title: Text(
                "Ids  :",
                style: Theme.of(context).textTheme.headline5,
              )),
              SizedBox(
                height: 10,
              ),
              (widget.data.data()["ids"] == null ||
                      widget.data.data()["ids"].length != 3)
                  ? Text("Ids Not yet added")
                  : Ids(widget.data.data()["ids"], _width)
            ],
          ),
        ),
      ),
    );
  }
}
