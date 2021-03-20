import 'package:adminapp/pages/exportPages/exportAllTransactions.dart';
import 'package:adminapp/pages/exportPages/exportUnpaidTransaction.dart';
import 'package:flutter/material.dart';

class Export extends StatefulWidget {
  Export({Key key}) : super(key: key);

  @override
  _ExportState createState() => _ExportState();
}

class _ExportState extends State<Export> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Export Your Data"),
        ),
        body: Container(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExportUnpaidTransaction()));
                    },
                    child: Container(
                      child: Center(
                        child: Text("All Unpaid Transaction"),
                      ),
                    )),
              ),
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExportAllTransaction()));
                    },
                    child: Container(
                      child: Center(
                        child: Text("All Transactions"),
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}
