
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

Ids(List<dynamic> ids, double _width) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: _width,
        width: _width,
        child: PinchZoom(
            image: CachedNetworkImage(
                imageUrl: ids[0],
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator(
                      value: progress.progress,
                    ),
                fit: BoxFit.fill)),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        height: _width,
        width: _width,
        child: PinchZoom(
            image: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator(
                      value: progress.progress,
                    ),
                imageUrl: ids[1],
                fit: BoxFit.fill)),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        height: _width,
        width: _width,
        child: PinchZoom(
            image: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator(
                      value: progress.progress,
                    ),
                imageUrl: ids[2],
                fit: BoxFit.fill)),
      ),
      SizedBox(
        height: 20,
      )
    ],
  );
}