import 'package:e_amarseba_verify/screens/scanner_screen.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Amarseba User Live Image',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: '/face-verify',
      home: const QRScannerPage(),
      // home: const QRScannerPage(),
    );
  }
}
