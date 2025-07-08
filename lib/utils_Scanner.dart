import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';

class UtilsScanner {
  UtilsScanner._();

  static Future<CameraDescription> getCamera(CameraLensDirection cameraLensDirection) async {
    return await availableCameras().then(
          (List<CameraDescription> cameras) =>
          cameras.firstWhere((camera) => camera.lensDirection == cameraLensDirection),
    );
  }

  static ImageRotation rotationintToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return ImageRotation.rotation0;
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      case 270:
        return ImageRotation.rotation270;
      default:
        throw ArgumentError('Invalid rotation value: $rotation');
    }
  }

  /// Concatenate camera image planes into single byte buffer
  static Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  /// Build metadata for FirebaseVisionImage
  static FirebaseVisionImageMetadata buildMetaData(
      CameraImage image,
      ImageRotation rotation,
      ) {
    return FirebaseVisionImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      rawFormat: image.format.raw,
      planeData: image.planes.map(
            (Plane plane) {
          return FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
  }

  /// Detect using the given detectInImage function
  static Future<dynamic> detect({
    required CameraImage image,
    required Future<dynamic> Function(FirebaseVisionImage image) detectInImage,
    required int imageRotation,
  }) async {
    final metadata = buildMetaData(image, rotationintToImageRotation(imageRotation));

    final visionImage = FirebaseVisionImage.fromBytes(
      concatenatePlanes(image.planes),
      metadata,
    );

    return await detectInImage(visionImage);
  }
}
