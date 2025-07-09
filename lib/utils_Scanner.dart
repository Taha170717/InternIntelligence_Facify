import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';

class UtilsScanner {
  UtilsScanner._();

  static Future<CameraDescription> getCamera(CameraLensDirection cameraLensDirection) async {
    return await availableCameras().then(
          (List<CameraDescription> cameras) =>
          cameras.firstWhere((camera) => camera.lensDirection == cameraLensDirection),
    );
  }

  static InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        throw ArgumentError('Invalid rotation value: $rotation');
    }
  }

  static InputImageFormat imageFormatFromRaw(int rawFormat) {
    switch (rawFormat) {
      case 35:
        return InputImageFormat.nv21;
      case 17:
        return InputImageFormat.yv12;
      default:
        return InputImageFormat.nv21; // fallback
    }
  }

  static Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  static InputImageMetadata buildMetaData(CameraImage image, InputImageRotation rotation) {
    return InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: imageFormatFromRaw(image.format.raw),
      bytesPerRow: image.planes.first.bytesPerRow,
    );
  }

  static Future<List<Face>> detect({
    required CameraImage image,
    required FaceDetector faceDetector,
    required int imageRotation,
  }) async {
    final InputImageRotation rotation = rotationIntToImageRotation(imageRotation);
    final metadata = buildMetaData(image, rotation);
    final inputImage = InputImage.fromBytes(
      bytes: concatenatePlanes(image.planes),
      metadata: metadata,
    );

    final List<Face> faces = await faceDetector.processImage(inputImage);
    return faces;
  }
}
