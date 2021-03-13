import 'package:adminapp/models/dealerModel.dart';
import 'package:adminapp/pages/individualDealer.dart';
import 'package:adminapp/pages/individualRejectedDealer.dart';
import 'package:adminapp/pages/individualUnverifiedDealer.dart';
import 'package:adminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DealersComplete extends StatelessWidget {
  const DealersComplete({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Dealers"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<Dealer>>(
        stream: FirebaseFirestore.instance
            .collection("Member")
            .orderBy("dealerId")
            .where("dealerId", isGreaterThanOrEqualTo: "")
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
                  return Center(child: Text("No Dealers yet"));
                else
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data[index].dealerId == "None")
                          return Card(
                            color: Colors.red,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ListTile(
                              title: Text(
                                snapshot.data[index].firmName ??
                                    snapshot.data[index].name ??
                                    "Not Available",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                (snapshot.data[index].phone == null ||
                                        snapshot.data[index].phone == "")
                                    ? "Phone Not Available"
                                    : snapshot.data[index].phone,
                                style: TextStyle(color: Colors.white),
                              ),
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
                        else if (snapshot.data[index].phone == null ||
                            snapshot.data[index].phone == "")
                          return Card(
                            color: Colors.deepOrangeAccent,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ListTile(
                              title: Text(
                                "On Phone Verification Page",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                snapshot.data[index].name,
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IndividualUnverifiedDealer(
                                              dealer: snapshot.data[index],
                                            )));
                              },
                            ),
                          );
                        else if (snapshot.data[index].ids.length < 3)
                          return Card(
                            color: Colors.deepOrangeAccent,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ListTile(
                              title: Text(
                                "On Registration Page",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                snapshot.data[index].name,
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IndividualUnverifiedDealer(
                                              dealer: snapshot.data[index],
                                            )));
                              },
                            ),
                          );
                        else
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ListTile(
                              title: Text(
                                snapshot.data[index].firmName ??
                                    "Not Available",
                              ),
                              subtitle: Text(snapshot.data[index].phone),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => IndividualDealer(
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
