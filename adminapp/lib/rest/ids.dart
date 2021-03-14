
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
                )),
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
                )),
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
                )),
      ),
      SizedBox(
        height: 20,
      )
    ],
  );
}