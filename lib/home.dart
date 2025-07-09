import 'package:camera/camera.dart';
import 'package:facify/utils_Scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool isworking = false;
  CameraController? cameraController;
  FaceDetector? faceDetector;
  Size? size;
  List<Face> faces = [];
  CameraDescription? description;
  CameraLensDirection cameraDirection = CameraLensDirection.front;
  late AnimationController _animationController;

  initCamera() async {
    description = await UtilsScanner.getCamera(cameraDirection);

    cameraController = CameraController(description!, ResolutionPreset.medium);

    faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        enableTracking: true,
        minFaceSize: 0.1,
      ),
    );



    await cameraController!.initialize().then((_) {
      if (!mounted) return;

      cameraController!.startImageStream((imageFromStream) {
        if (!isworking) {
          isworking = true;
          performDetectionOnStreamFrame(imageFromStream);
        }
      });
    });
  }

  dynamic scanResults;
  performDetectionOnStreamFrame(CameraImage cameraImage) async {
    final results = await UtilsScanner.detect(
      image: cameraImage,
      faceDetector: faceDetector!,
      imageRotation: description!.sensorOrientation,
    );

    setState(() {
      scanResults = results;
    });

    isworking = false;
  }


  @override
  void initState() {
    super.initState();
    initCamera();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    super.dispose();
    cameraController!.dispose();
    faceDetector!.close();
    _animationController.dispose();
  }

  Widget buildResult() {
    if (scanResults == null ||
        cameraController == null ||
        !cameraController!.value.isInitialized) {
      return const Text("");
    }

    final Size imageSize = Size(cameraController!.value.previewSize!.height,
        cameraController!.value.previewSize!.width);

    CustomPainter customPainter =
    FaceDetectorPainter(imageSize, scanResults, cameraDirection);

    return CustomPaint(painter: customPainter);
  }

  toggleCameratoFrontBack() async {
    _animationController.forward(from: 0);
    if (cameraDirection == CameraLensDirection.back) {
      cameraDirection = CameraLensDirection.front;
    } else {
      cameraDirection = CameraLensDirection.back;
    }

    await cameraController!.stopImageStream();
    await cameraController!.dispose();

    setState(() {
      cameraController = null;
    });

    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackWidgetChildren = [];
    size = MediaQuery.of(context).size;

    if (cameraController != null) {
      stackWidgetChildren.add(
        Positioned(
          top: 0,
          left: 0,
          width: size!.width,
          height: size!.height - 250,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              child: (cameraController!.value.isInitialized)
                  ? AspectRatio(
                aspectRatio: cameraController!.value.aspectRatio,
                child: CameraPreview(cameraController!),
              )
                  : Container(),
            ),
          ),
        ),
      );
    }

    stackWidgetChildren.add(
      Positioned(
        top: 0,
        left: 0,
        width: size!.width,
        height: size!.height - 250,
        child: buildResult(),
      ),
    );

    stackWidgetChildren.add(
      Positioned(
        bottom: 80,
        left: 0,
        width: size!.width,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(80),
              border: Border.all(color: Colors.white30, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 1,
                )
              ],
            ),
            child: RotationTransition(
              turns:
              Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: IconButton(
                onPressed: toggleCameratoFrontBack,
                icon: Icon(Icons.cameraswitch_rounded),
                iconSize: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0f0c29), Color(0xff302b63), Color(0xff24243e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(children: stackWidgetChildren),
      ),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
      this.absoluteImageSize, this.faces, this.cameraLensDirection);

  final Size absoluteImageSize;
  final List<Face> faces;
  CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..color = Colors.greenAccent.shade400;

    for (Face face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          cameraLensDirection == CameraLensDirection.front
              ? (absoluteImageSize.width - face.boundingBox.right) * scaleX
              : face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY,
          cameraLensDirection == CameraLensDirection.front
              ? (absoluteImageSize.width - face.boundingBox.left) * scaleX
              : face.boundingBox.right * scaleX,
          face.boundingBox.bottom * scaleY,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
