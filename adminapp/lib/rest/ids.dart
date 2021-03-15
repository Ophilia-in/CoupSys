
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

Ids(List<dynamic> ids, double _width) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: _width/2,
        width: _width/1.5,
        child: ExtendedImage.network(
            ids[0],
            fit: BoxFit.contain,cache: true,

            border: Border.all(color: Colors.red, width: 4.0),
            //enableLoadState: false,
            mode: ExtendedImageMode.gesture,
            handleLoadingProgress: true,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
                initialAlignment: InitialAlignment.center,
              );
            },
          )
        // PinchZoom(
        //     image: CachedNetworkImage(
        //   imageUrl: ids[0],
        //   progressIndicatorBuilder: (context, url, progress) =>
        //       CircularProgressIndicator(
        //     value: progress.progress,
        //   ),
        // )),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
          height: _width/2,
          width: _width/1.5,
          child: ExtendedImage.network(
            ids[1],
            fit: BoxFit.contain,
            cache: true,

            handleLoadingProgress: true,
            border: Border.all(color: Colors.red, width: 4.0),
            //enableLoadState: false,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
                initialAlignment: InitialAlignment.center,
              );
            },
          )
          // PinchZoom(
          //     image: CachedNetworkImage(
          //         progressIndicatorBuilder: (context, url, progress) =>
          //             CircularProgressIndicator(
          //               value: progress.progress,
          //             ),
          //         imageUrl: ids[1],
          //         )),
          ),
      SizedBox(
        height: 10,
      ),
      Container(
        height: _width/2,
        width: _width/1.5,
        child:
        ExtendedImage.network(
            ids[2],
            fit: BoxFit.contain,
            cache: true,

            handleLoadingProgress: true,
            border: Border.all(color: Colors.red, width: 4.0),
            //enableLoadState: false,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
                initialAlignment: InitialAlignment.center,
              );
            },
          )
        //  PinchZoom(
        //     image: CachedNetworkImage(
        //   progressIndicatorBuilder: (context, url, progress) =>
        //       CircularProgressIndicator(
        //     value: progress.progress,
        //   ),
        //   imageUrl: ids[2],
        // )),
      ),
      SizedBox(
        height: 20,
      )
    ],
  );
}
