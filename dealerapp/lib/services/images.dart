import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'dart:async';
import 'dart:convert';

Future<List<CachedNetworkImage>> fetchForHomePage() async {
  List temp = await fetchPages();

  temp = temp.map((e) => e.toString()).toList();
  return temp
      .map((e) => CachedNetworkImage(
            progressIndicatorBuilder: (context, _, prog) {
              return Center(
                  child: CircularProgressIndicator(
                value: prog.totalSize != null
                    ? prog.downloaded / prog.totalSize
                    : null,
              ));
            },
            imageUrl: e,
          ))
      .toList();
}

Future<List<List>> fetch() async {
  List temp1 = await fetchProducts();
  List temp2 = await fetchPages();
  temp1 = temp1.map((e) => e.toString()).toList();
  temp2 = temp2.map((e) => e.toString()).toList();
  return [temp1, temp2].toList();
}

Future<List> fetchProducts() async {
  final response = await http.get(Uri.parse(jsonurl));
  if (response.statusCode == 200) {
    return json.decode(response.body)["products"];
  } else {
    throw Exception('Failed to load');
  }
}

Future<List> fetchPages() async {
  final response = await http.get(Uri.parse(jsonurl));
  if (response.statusCode == 200) {
    return json.decode(response.body)["pages"];
  } else {
    throw Exception('Failed to load');
  }
}
