import 'package:adminapp/models/dealerModel.dart';
import 'package:adminapp/pages/dealerTransactionLog.dart';
import 'package:adminapp/rest/ids.dart';
import 'package:excel/excel.dart';
import 'package:extended_image/extended_image.dart';

// import 'dart:html' as html;
// import 'dart:js' as js;
import 'package:flutter/material.dart';

import 'dart:convert' show utf8;

// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' show AnchorElement;
import 'package:intl/intl.dart';

class IndividualDealer extends StatelessWidget {
  final Dealer dealer;
  const IndividualDealer({Key key, this.dealer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(dealer.firmName),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DealerTransactionLog(
                          uid: dealer.uid,
                        )));
              },
              child: Text("View Log"))
        ],
      ),
      body: Container(
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
                title: Text("Firm Name"),
                subtitle: Text(dealer.firmName ?? "Not Available"),
              ),
              ListTile(
                title: Text("Account Type"),
                subtitle: Text(dealer.accountType ?? ""),
              ),
              ListTile(
                title: Text("Dealer ID"),
                subtitle: Text(dealer.dealerId ?? ""),
              ),
              ListTile(
                title: Text("Phone Number"),
                subtitle: Text(dealer.phone ?? "Not yet added"),
              ),
              ListTile(
                title: Text("Email"),
                subtitle: Text(dealer.email),
              ),
              ListTile(
                title: Text("Earned"),
                subtitle: Text(dealer.earned.toString()),
              ),
              ListTile(
                title: Text("Points"),
                subtitle: Text(dealer.points.toString()),
              ),
              ListTile(
                title: Text("Created At"),
                subtitle:
                    Text(DateFormat('dd MMM y kk:mm').format(dealer.createdAt)),
              ),
              ExpansionTile(
                  children: [
                    (dealer.ids == null || dealer.ids.length != 3)
                        ? Text("Ids Not yet added")
                        : Ids(dealer.ids, _width)
                  ],
                  title: Text(
                    "Ids  :",
                    style: Theme.of(context).textTheme.headline5,
                  )),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TextButton(
        onPressed: () async {
          var excel = Excel.createExcel();
          var sheet = excel['Sheet1'];
          var cell1 = sheet.cell(CellIndex.indexByString("A1"));
          cell1.value = "Name";
          cell1 = sheet.cell(CellIndex.indexByString("B1"));
          cell1.value = dealer.name;
          cell1 = sheet.cell(CellIndex.indexByString("A2"));
          cell1.value = "Phone Number";
          cell1 = sheet.cell(CellIndex.indexByString("B2"));
          cell1.value = dealer.phone ?? "Not Available";
          cell1 = sheet.cell(CellIndex.indexByString("A3"));
          cell1.value = "Firm Name";
          cell1 = sheet.cell(CellIndex.indexByString("B3"));
          cell1.value = dealer.firmName ?? "Not Available";
          cell1 = sheet.cell(CellIndex.indexByString("A4"));
          cell1.value = "Account Type";
          cell1 = sheet.cell(CellIndex.indexByString("B4"));
          cell1.value = dealer.accountType;
          cell1 = sheet.cell(CellIndex.indexByString("A5"));
          cell1.value = "Email";
          cell1 = sheet.cell(CellIndex.indexByString("B5"));
          cell1.value = dealer.email;

          cell1 = sheet.cell(CellIndex.indexByString("A6"));
          cell1.value = "Points";
          cell1 = sheet.cell(CellIndex.indexByString("B6"));
          cell1.value = dealer.points ?? "Not Available";

          cell1 = sheet.cell(CellIndex.indexByString("A7"));
          cell1.value = "Total Earned So Far";
          cell1 = sheet.cell(CellIndex.indexByString("B7"));
          cell1.value = dealer.earned;

          cell1 = sheet.cell(CellIndex.indexByString("A8"));
          cell1.value = "Dealer Id";
          cell1 = sheet.cell(CellIndex.indexByString("B8"));
          cell1.value = dealer.dealerId ?? "Not Yet Assigned";

          cell1 = sheet.cell(CellIndex.indexByString("A9"));
          cell1.value = "Created At";
          cell1 = sheet.cell(CellIndex.indexByString("B9 "));
          cell1.value = DateFormat('dd MMM y kk:mm').format(dealer.createdAt) ??
              "Not Available";
          cell1 = sheet.cell(CellIndex.indexByString("A10"));
          cell1.value = "Uid";
          cell1 = sheet.cell(CellIndex.indexByString("B10 "));
          cell1.value = dealer.uid;

          await excel.save(fileName: "Dealerdata" + dealer.phone + ".xlsx");
          // .then((onValue) {
          //   final pdfFile = html.Blob(
          //     onValue,
          //     'application/msexcel',
          //   );
          //   final pdfUrl = html.Url.createObjectUrl(pdfFile);
          //   final html.HtmlDocument doc = js.context['document'];
          //   final link = html.AnchorElement(href: pdfUrl);
          //   link.download = "Dealer.xlsx";
          //   doc.body?.append(link);
          //   link.click();
          //   link.remove();
          // });
        },
        child: SelectableText("Export to Excel"),
      ),
    );
  }
}
