import 'package:adminapp/models/dealerModel.dart';
import 'package:adminapp/rest/ids.dart';
import 'package:extended_image/extended_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class IndividualUnverifiedDealer extends StatelessWidget {
  const IndividualUnverifiedDealer({Key key, this.dealer}) : super(key: key);
  final Dealer dealer;

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width * 0.75;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(dealer.phone ?? "Not Yet Added"),
      ),  body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ExtendedImage.network(
                  dealer.photoUrl,
                  cache: true,
                ),
              ),
              ListTile(
                title: Text("Name"),
                subtitle: Text(dealer.name),
              ),
              ListTile(
                title: Text("Uid"),
                subtitle: Text(dealer.uid),
              ),
              ListTile(
                title: Text("Account Type"),
                subtitle: Text(dealer.accountType),
              ),
              ListTile(
                title: Text("Email"),
                subtitle: Text(dealer.email),
              ),
              ListTile(
                title: Text("Created At"),
                subtitle: Text(DateFormat('dd MMM y kk:mm')
                    .format(dealer.createdAt)),
              ),
              ListTile(
                  title: Text(
                "Ids  :",
                style: Theme.of(context).textTheme.headline5,
              )),
              SizedBox(
                height: 10,
              ),
              (dealer.ids == null ||
                      dealer.ids.length != 3)
                  ? Text("Ids Not yet added")
                  : Ids(dealer.ids, _width)
            ],
          ),
        ),
      ),
    );
  }
}
