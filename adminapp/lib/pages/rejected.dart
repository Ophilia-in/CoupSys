import 'package:adminapp/models/dealerModel.dart';
import 'package:adminapp/pages/individualRejectedDealer.dart';
import 'package:adminapp/pages/rejectedComplete.dart';
import 'package:adminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RejectedDealers extends StatelessWidget {
  const RejectedDealers({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rejected Dealers"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<Dealer>>(
        stream: FirebaseFirestore.instance
            .collection("Member")
            .orderBy("name")
            .where("dealerId", isEqualTo: "None")
            // .where("dealerId", isEqualTo: "None")
            .limit(10)
            .snapshots()
            .map(dealerfromSnapshots),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString() + "has Occurred"),
            );
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Text("Connection done");
                break;
              case ConnectionState.active:
                if (snapshot.data.length == 0)
                  return Center(child: Text("No Rejected Dealers yet"));
                else
                  return ListView.builder(
                      itemCount: snapshot.data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data.length) {
                          return ListTile(
                            title: Center(
                              child: TextButton(
                                child: Text("View ALL"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RejectedDealersComplete()));
                                },
                              ),
                            ),
                          );
                        }
                        return Card(
                          elevation: 8,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: ListTile(
                            title: Text(snapshot.data[index].firmName ??
                                snapshot.data[index].name ??
                                "Not Available"),
                            subtitle: Text(snapshot.data[index].phone ??
                                "Phone Number Not available"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          IndividualRejectedDealer(
                                            dealer: snapshot.data[index],
                                          )));
                            },
                          ),
                        );
                      });
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
