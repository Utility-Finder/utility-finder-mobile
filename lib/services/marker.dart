import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as im;

// Get and convert image from netowrk to marker icon
Future<BitmapDescriptor> createIconFromNetwork(
    String imageURL, Color color) async {
  // Read image
  File markerImageFile = await DefaultCacheManager().getSingleFile(imageURL);
  Uint8List markerImageBytes = await markerImageFile.readAsBytes();

  // Load marker base
  Uint8List markerBaseBytes =
      (await rootBundle.load('assets/markerBase.png')).buffer.asUint8List();

  // Re-size and crop marker image
  var img = im.decodeImage(markerImageBytes);
  final int targetSize = 120;
  img = im.copyResize(img, height: targetSize);
  img = im.copyCropCircle(
    img,
    radius: targetSize ~/ 2,
    center: im.Point(img.width ~/ 2, img.height ~/ 2),
  );

  // Re-color base
  var base = im.decodeImage(markerBaseBytes);
  color = color ?? Colors.black;
  base = im.colorOffset(base,
      red: color.red, blue: color.blue, green: color.green);

  // Combine marker image and base
  final int offset = base.width ~/ 2 - img.width ~/ 2;
  var res = im.copyInto(base, img,
      dstX: offset,
      dstY: offset,
      srcX: 0,
      srcY: 0,
      srcW: img.width,
      srcH: img.height);

  return BitmapDescriptor.fromBytes(im.encodePng(res));
}
