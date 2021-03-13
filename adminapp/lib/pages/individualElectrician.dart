import 'package:adminapp/models/dealerModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IndividualElectrician extends StatelessWidget {
  final Dealer electrician;
  const IndividualElectrician({Key key, this.electrician}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(electrician.name),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: electrician.photoUrl,
                ),
              ),
              ListTile(
                title: Text("Name"),
                subtitle: Text(electrician.name),
              ),
              ListTile(
                title: Text("Uid"),
                subtitle: Text(electrician.uid),
              ),
              ListTile(
                title: Text("Account Type"),
                subtitle: Text(electrician.accountType),
              ),
              ListTile(
                title: Text("Phone Number"),
                subtitle: Text(electrician.phone ?? 'Not Available'),
              ),
              ListTile(
                title: Text("Email"),
                subtitle: Text(electrician.email),
              ),
              ListTile(
                title: Text("Earned"),
                subtitle: Text(electrician.earned.toString()),
              ),
              ListTile(
                title: Text("Points"),
                subtitle: Text(electrician.points.toString()),
              ),
              ListTile(
                title: Text("Created At"),
                subtitle: Text(
                    DateFormat('dd MMM y kk:mm').format(electrician.createdAt)),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
