import 'package:electricianapp/pages/offers.dart';
import 'package:electricianapp/pages/transactions.dart';
import 'package:flutter/material.dart';


class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.blue,
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
               
                Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: _width / 15),
                    height: _height / 12,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: TabBar(
                        indicatorWeight: 4,
                        labelColor: Color(0xff93ea2e),
                        unselectedLabelColor: Colors.white,
                        indicatorColor: Color(0xff93ea2e),
                        tabs: [
                          Tab(
                            child: Text("Passbook"),
                          ),
                          Tab(
                            child: Text("Offers"),
                          ),
                        ])),
                Expanded(
                  child: Scaffold(
                    body: TabBarView(
                      children: [Transactions(), Offers()],
                    ),
                  ),
                )
              ],
            )));
  }
}
