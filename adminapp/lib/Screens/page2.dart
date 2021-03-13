import 'package:adminapp/pages/transactions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.blue,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              padding: EdgeInsets.symmetric(horizontal: _width / 15),
              height: _height / 20,
              color: Colors.blue,
              child: Center(
                  child: Text("Passbook",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.white),
                      ))),
            ),
            Divider(
              thickness: 4,
              color: Colors.red,
              indent: 35,
              endIndent: 35,
            ),
            Expanded(
              child: Scaffold(
                body: Transactions(),
              ),
            )
          ],
        ));
  }
}
