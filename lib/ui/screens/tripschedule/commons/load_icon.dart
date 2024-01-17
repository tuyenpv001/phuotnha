import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:social_media/data/env/env.dart';

Future<Uint8List> getIconByType(String imageName) async {
  Uint8List? image = await loadNetworkImage(imageName);
  final ui.Codec markerImageCodec = await instantiateImageCodec(
      image.buffer.asUint8List(),
      targetHeight: 125,
      targetWidth: 125);

  final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
  final ByteData? byteData =
      await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List resizedImage = byteData!.buffer.asUint8List();
  return resizedImage;
}

Future<Uint8List> loadNetworkImage(String nameImage) async {
  final complater = Completer<ImageInfo>();
  var image = NetworkImage(Environment.baseUrl + nameImage);
  image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((info, synchronousCall) => complater.complete(info)));

  final imageInfo = await complater.future;

  final byteData =
      await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
