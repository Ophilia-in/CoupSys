import 'dart:ui';

import 'package:electricianapp/pages/addCoupan.dart';
import 'package:electricianapp/Screens/page2.dart';
import 'package:electricianapp/pages/redeemPoints.dart';
import 'package:electricianapp/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:radial_charts/radial_charts.dart';
import 'package:hive/hive.dart';

import '../services/constant.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");

  Size _chartSize;

  double nextRange;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    _chartSize = Size(_width / 2, _width / 2);
    return PageView(
      scrollDirection: Axis.vertical,
      children: [
        Stack(
          children: [
            ValueListenableBuilder(
                valueListenable: Hive.box<MyUser>(userBox).listenable(),
                builder: (context, Box<MyUser> value, myChild) {
                  final temp = value.get("myuser");
                  nextRange = slots
                      .firstWhere((element) => (element > temp.points),
                          orElse: () => 10000000)
                      .toDouble();
                  if (value.isEmpty) {
                    return Text("Error");
                  }

                  return Column(
                    children: [
                      Container(
                        color: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Card(
                          elevation: 6,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            children: [
                              new Center(
                                child: new AnimatedCircularChart(
                                  edgeStyle: SegmentEdgeStyle.flat,
                                  duration: Duration(seconds: 1),
                                  holeLabel:
                                      temp.points.toString() + " \nPoints",
                                  labelStyle: TextStyle(
                                      fontSize: _width / 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  size: _chartSize,
                                  initialChartData: [
                                    CircularStackEntry([
                                      CircularSegmentEntry(
                                          temp.points.toDouble(),
                                          // Colors.blue[600],
                                          Color(0xff0066cc),
                                          strokeWidth: 15),
                                      CircularSegmentEntry(
                                          nextRange - temp.points,
                                          Colors.grey[300],
                                          // Colors.lightBlueAccent,
                                          strokeWidth: 20)
                                    ]),
                                  ],
                                  chartType: CircularChartType.Radial,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(0),
                                      height: _height / 13,
                                      decoration: BoxDecoration(
                                          color: Color(0xff0066cc),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(30.0),
                                              bottomRight:
                                                  Radius.circular(30.0))),
                                      child: Center(
                                          child: Text(
                                        "You Need " +
                                            (nextRange - temp.points)
                                                .toInt()
                                                .toString() +
                                            " more to reach ${nextRange.toInt()}",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: _width / 25),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      Colors.blue,
                                      Colors.blue,
                                      Colors.white,
                                    ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: _width / 2.2,
                                      margin: EdgeInsets.symmetric(
                                          vertical: _height / 40,
                                          horizontal: _width / 50),
                                      decoration: BoxDecoration(
                                          color: Color(0xff01c5c4),
                                          // color: Color(0xff7579e7),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: FlatButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    AddCoupan())),
                                        child: Text("+ New Coupon",
                                            style: GoogleFonts.poppins(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        color:
                                                            Color(0xfff1f6f9),
                                                        fontWeight:
                                                            FontWeight.w500))),
                                      ),
                                    ),
                                    Container(
                                      width: _width / 2.1,
                                      margin: EdgeInsets.fromLTRB(
                                          0,
                                          _height / 40,
                                          _width / 50,
                                          _height / 40),
                                      decoration: BoxDecoration(
                                          color: Color(0xff01c5c4),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: FlatButton(
                                        onPressed: () {
                                          if (temp.points < 500) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You need ${500 - temp.points} points more to be able to redeem");
                                          } else {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        RedeemPoints()));
                                          }
                                        },
                                        child: Text("Redeem Points",
                                            style: GoogleFonts.poppins(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        color:
                                                            Color(0xfff1f6f9),
                                                        fontWeight:
                                                            FontWeight.w500))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "You have Earned",
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.headline5,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                    width: _width * 0.75,
                                    decoration: BoxDecoration(
                                      // color: Colors.green,
                                      image: DecorationImage(
                                          alignment: Alignment.bottomCenter,
                                          image: AssetImage(
                                            "assets/ribbon.png",
                                          ),
                                          fit: BoxFit.fill),
                                      // color: Colors.green[100],
                                    ),
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 0, 20, 10),
                                    child: Center(
                                      child: Text("Rs. ${temp.earned}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600)),
                                    )),
                              ),
                              Expanded(
                                flex: 8,
                                child: Container(
                                  width: _width,
                                  color: Colors.blue,
                                  child: Image.asset(
                                    "assets/people.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            Positioned(
              bottom: 0,
              child: Row(
                children: [
                  Lottie.asset("assets/swipe.json",
                      width: _width, height: 100, alignment: Alignment.center),
                ],
              ),
            )
          ],
        ),
        Page2()
      ],
    );
  }
}
