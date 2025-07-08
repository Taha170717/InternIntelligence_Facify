import 'package:camera/camera.dart';
import 'package:facify/utils_Scanner.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isworking = false;
  CameraController? cameraController;
  FaceDetector? faceDetector;
  Size? size;
  List<Face> faces = [];
  CameraDescription? description;
  CameraLensDirection cameraDirection = CameraLensDirection.front;
  initCamera() async {
    description = await UtilsScanner.getCamera(cameraDirection);

    cameraController = CameraController(description!, ResolutionPreset.medium);

    faceDetector = FirebaseVision.instance.faceDetector(
      const FaceDetectorOptions(
        enableClassification: true,
        enableTracking: true,
        minFaceSize: 0.1,
        mode: FaceDetectorMode.fast,
      ),
    );

    await cameraController!.initialize().then((_) {
      if (!mounted) return;

      cameraController!.startImageStream((imageFromStream) {
        if (!isworking) {
          isworking = true;

        }
      });
    });
  }

  dynamic scanResults;
  performDetectionOnStreamFrame(CameraImage cameraImage)async{
    UtilsScanner.detect(
      image: cameraImage,
      detectInImage: faceDetector!.processImage,
      imageRotation: description!.sensorOrientation,
    ).then((dynamic results){
      setState(() {
        scanResults = results;
      });
    }).whenComplete((){
      isworking = false;

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController!.dispose();
    faceDetector!.close();
  }
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
