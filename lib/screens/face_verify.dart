import 'dart:io';
import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:http/http.dart' as http;

class FaceVerifyScreen extends StatefulWidget {
  final String username;
  final String code;

  const FaceVerifyScreen({required this.username, required this.code, super.key});

  @override
  State<FaceVerifyScreen> createState() => _FaceVerifyScreenState();
}

class _FaceVerifyScreenState extends State<FaceVerifyScreen> {
  File? _capturedImage;
  late FaceCameraController controller;

  @override
  void initState() {
    controller = FaceCameraController(
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        setState(() => _capturedImage = image);
      },
      onFaceDetected: (Face? face) {
        // Do something
      },
    );
    super.initState();
  }

  Future<void> _sendDataToServer() async {
    if (_capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('কোনো ছবি ধারণ করা হয়নি')),
      );
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://beta.e-amarseba.com/profile-update-by-qr'),
    );

    request.files.add(await http.MultipartFile.fromPath('profile_photo_path', _capturedImage!.path));
    request.fields['username'] = widget.username;
    request.fields['qr_code'] = widget.code;

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        debugPrint('API Code: $response.statusCode');
        debugPrint('API Response: ${await response.stream.bytesToString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ছবি সফলভাবে আপলোড করা হয়েছে৷')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('প্রোফাইল আপডেট করতে ব্যর্থ হয়েছে')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(builder: (context) {
          if (_capturedImage != null) {
            return Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.file(
                    _capturedImage!,
                    width: double.maxFinite,
                    fit: BoxFit.fitWidth,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await controller.startImageStream();
                          setState(() => _capturedImage = null);
                        },
                        child: const Text(
                          'Capture Again',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _sendDataToServer,
                        child: const Text(
                          'Upload',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
          return SmartFaceCamera(
            autoDisableCaptureControl: true,
            controller: controller,
            messageBuilder: (context, face) {
              if (face == null) {
                return _message('আপনার মুখ ক্যামেরায় রাখুন');
              }
              if (!face.wellPositioned) {
                return _message('আপনার মুখ বক্সের মাঝখানে রাখুন');
              }
              return const SizedBox.shrink();
            },
          );
        }),
      ),
    );
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 14, height: 1.5, fontWeight: FontWeight.w400),
        ),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
