
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:electricianapp/services/images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class Offers extends StatefulWidget {
  Offers({Key key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: 
      FutureBuilder<List<List>>(
          future: fetch(),
          builder: (context, snapshot) {
            if (!snapshot.hasError) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    // Text(
                    //   "Products",
                    //   style:
                    //       TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                    // ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30)),
                        child: CarouselSlider(
                          items: snapshot.data[0]
                              .map((e) => CachedNetworkImage(
                                    progressIndicatorBuilder:
                                        (context, _, prog) {
                                      return CircularProgressIndicator(
                                        value: prog.downloaded.toDouble(),
                                      );
                                    },
                                    imageUrl: e,
                                  ))
                              .toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            // onPageChanged: (index, reason) {
                            //   setState(() {
                            //     _current = index;
                            //   });
                            // }
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30)),
                        child: CarouselSlider(
                          items: snapshot.data[1]
                              .map((e) => CachedNetworkImage(
                                    imageUrl: e,
                                  ))
                              .toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            // onPageChanged: (index, reason) {
                            //   setState(() {
                            //     _current = index;
                            //   });
                            // }
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else
              return Text(snapshot.error.toString());
          }),
      // bottomNavigationBar: FlatButton(
      //   color: Colors.green,
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) => Scaffold(
      //             appBar: AppBar(
      //               title: Text("Catalogue PDF"),
      //             ),
      //             body: PDF(
      //               fitEachPage: true,
      //               enableSwipe: true,
      //               swipeHorizontal: true,
      //             ).cachedFromUrl(
      //                 "https://github.com/Official-Ophilia/Official-Ophilia.github.io/raw/master/3D%20Image/Final%20Catalogue%20.pdf"))));
      //   },
      //   child: Text("View Catalouge Pdf"),
      // ),
    );
  }
}
