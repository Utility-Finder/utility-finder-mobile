import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as im;

// Get and convert image from netowrk to marker icon
Future<BitmapDescriptor> getIconFromNetwork(String imageURL) async {
  // Read image
  File markerImageFile = await DefaultCacheManager().getSingleFile(imageURL);
  Uint8List markerImageBytes = await markerImageFile.readAsBytes();

  // Convert to marker image
  int targetSize = 120;
  var img = im.decodeImage(markerImageBytes);
  img = im.copyResize(img, height: targetSize);
  img = im.copyCropCircle(
    img,
    radius: targetSize ~/ 2,
    center: im.Point(img.width ~/ 2, img.height ~/ 2),
  );

  markerImageBytes = im.encodePng(img);
  return BitmapDescriptor.fromBytes(markerImageBytes);
}
