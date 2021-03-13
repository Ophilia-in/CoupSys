import 'dart:ui';
import 'package:adminapp/Screens/addCoupan.dart';
import 'package:adminapp/pages/dealers.dart';
import 'package:adminapp/pages/electricians.dart';
import 'package:adminapp/pages/logs.dart';
import 'package:adminapp/Screens/page2.dart';
import 'package:adminapp/Screens/verify.dart';
import 'package:adminapp/pages/pending.dart';
import 'package:adminapp/pages/rejected.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return PageView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      children: [page1(_height, _width), Page2()],
    );
  }

  Widget page1(var _height, var _width) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue
          // Color(0xff0066cc)
          // gradient: LinearGradient(colors: [
          //   Colors.blue,
          //   Colors.blue,
          //   Colors.white,
          // ], begin: Alignment.topRight, end: Alignment.bottomLeft),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Container(
                  // margin:
                  //     EdgeInsets.symmetric(horizontal: _width / 25, vertical: 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // color: Color(0xff000666),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: _height / 8,
                  width: _width / 2.5,
                  child: FlatButton(
                    child: Text(
                      "Rejected Dealers",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          textStyle: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.red)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RejectedDealers()));
                    },
                  ),
                ),
              ),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Container(
                  // margin:
                  //     EdgeInsets.symmetric(horizontal: _width / 25, vertical: 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // color: Color(0xff000666),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: _height / 8,
                  width: _width / 2.5,
                  child: FlatButton(
                    child: Text(
                      "Pending Transactions",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        textStyle: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.blue),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PendingTransactionsComplete()));
                    },
                  ),
                ),
              ),
            ],
          ),
          display1(
            context,
            () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Logs()));
            },
            "View Transaction Log",
            _height,
            _width,
            // Colors.green,
            // Color(0xff4CD7D0),
            Color(0xff05445E),
            Color(0xff189AB4),
            // Colors.tealAccent,
            Color(0xFF584846),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              display2(context, () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Verify()));
              },
                  "Verify Dealers",
                  _height,
                  _width / 2,
                  // Color(0xffFBE7C6),
                  // Color(0xffFBE7C6),
                  // Color(0xff29A0B1),
                  // Color(0xff29A0B1),
                  Color(0xff1DC690),
                  Color(0xff1DC690),

                  // Colors.cyan,
                  // Colors.white,
                  Color(0xFF584846),
                  "verify",
                  Alignment.topLeft,
                  Alignment.bottomRight),
              display2(context, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddCoupans()));
              },
                  "Add Coupans",
                  _height,
                  _width / 2,
                  // Color(0xffB4F8C8),
                  // Color(0xffB4F8C8),

                  Color(0xfff5b461),
                  Color(0xfff5b461),
                  Color(0xFF584846),
                  "coupon",
                  Alignment.topRight,
                  Alignment.bottomLeft),
              display2(
                context,
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dealers()));
                },
                "View Dealers",
                _height,
                _width / 2,
                // Color(0xff0e918c),
                // Color(0xff0e918c),
                Color(0xffe6739f),
                Color(0xffe6739f),

                // Color(0xffFFAEBC),
                // Color(0xffFFAEBC),
                Color(0xFF584846), "dealer",
                Alignment.bottomLeft,
                Alignment.topRight,
              ),
              display2(context, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Electrician()));
              },
                  "View Electricians",
                  _height,
                  _width / 2,
                  // Color(0xffA0E7E5),
                  // Color(0xffA0E7E5),

                  Color(0xffec524b),
                  Color(0xffec524b),

                  // Colors.red,
                  // Colors.white,
                  Color(0xFF584846),
                  "electrician",
                  Alignment.bottomRight,
                  Alignment.topLeft)
            ],
          ),
        ],
      ),
    );
  }
}

display1(BuildContext context, onTap, String title, var h, var w, Color c1,
    Color c2, Color textc,
    [AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight]) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: w / 20, vertical: h * 0.01),
    child: GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.black,
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffEAEAE0),
              Color(0xffEAEAE0),
            ], begin: begin, end: end),
            borderRadius: BorderRadius.circular(15),
          ),
          width: w - 40,
          height: h * 0.1,
          child: Center(
            // padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Image.asset("assets/passbook.png"),
                  height: h * 0.07,
                ),
                Text(title,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.grey[900])),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

display2(BuildContext context, onTap, String title, var h, var w, Color c1,
    Color c2, Color textc, String image,
    [AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight]) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: w / 20, vertical: h * 0.01),
    child: GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.black,
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [c1, c2], begin: begin, end: end),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                // padding: const EdgeInsets.all(20.0),
                child: Text(title,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6),
              ),
              Container(
                padding: const EdgeInsets.all(0),
                width: w,
                height: h * 0.09,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.arrow_forward,
                    //   size: w * 0.2,
                    // ),
                    Container(
                      child: Image.asset(
                        "assets/$image.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
