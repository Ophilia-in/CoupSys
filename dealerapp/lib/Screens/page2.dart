import 'package:dealerapp/Screens/offers.dart';
import 'package:dealerapp/pages/transactions.dart';
import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.blue,
            // Color(0xff0066cc),
            // Colors.cyan,
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: _width / 15),
                    height: _height / 12,
                    decoration: BoxDecoration(
                        color: 
                        Colors.blue,
                        //  Color(0xff0066cc),
                        // Colors.cyan,
                        borderRadius: BorderRadius.circular(20)),
                    child: TabBar(
                        indicatorWeight: 4,
                        labelColor: Colors.red,
                        unselectedLabelColor: Colors.white,
                        indicatorColor: Colors.red,
                        tabs: [
                          Tab(
                            child: Text("Passbook"),
                          ),
                          Tab(
                            child: Text("Offers"),
                          ),
                        ])),
                Expanded(
                  child:
                      // Scaffold(
                      //   body:
                      const TabBarView(
                    children: [const Transactions(), const Offers()],
                  ),
                  // ),
                )
              ],
            )));
  }
}
