import 'package:facify/Splash_Screen.dart';
import 'package:facify/home.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp( FaceApp());
}

class FaceApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      title: 'Face Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: SplashScreen()
    );
  }
  
}