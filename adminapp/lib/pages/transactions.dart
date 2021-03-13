import 'package:adminapp/models/individualTransaction.dart';
import 'package:adminapp/models/transactionModel.dart';
import 'package:adminapp/models/userModel.dart';
import 'package:adminapp/pages/transactionsComplete.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../services/constant.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");

  // User user = FirebaseAuth.instance.currentUser;
  @override                                                                         
  Widget build(BuildContext context) {
    final transactionStream = Provider.of<List<TransactionRecord>>(context);

    return Scaffold(
        backgroundColor: Color(0xff0066cc),
        body: (transactionStream == null)
            ? Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: Lottie.asset("assets/bulb.json"))
            : (transactionStream.length == 0)
                ? Center(child: Text("No Transactions yet"))
                : Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.blue,
                      Colors.blue,
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                    child: ListView.builder(
                        itemCount: transactionStream.length + 1,
                        itemBuilder: (context, index) {
                          if (index == transactionStream.length) {
                            return ListTile(
                              title: Center(
                                child: TextButton(
                                  child: Text(
                                    "View ALL",
                                    style: TextStyle(color: Color(0xff000666)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionComplete()));
                                  },
                                ),
                              ),
                            );
                          }
                          return IndividualTransactionRecord(
                            transactionRecord: transactionStream[index],
                          );
                        })));
  }
}
