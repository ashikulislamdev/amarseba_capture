import 'dart:io';
import 'package:e_amarseba_verify/widgets/constants.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'success_page.dart';

class FaceVerifyScreen extends StatefulWidget {
  final String username;
  final String code;
  const FaceVerifyScreen({super.key, required this.code, required this.username});

  @override
  State<FaceVerifyScreen> createState() => _FaceVerifyScreenState();
}

class _FaceVerifyScreenState extends State<FaceVerifyScreen> {
  File? _capturedImage;
  late FaceCameraController controller;
  bool _isUploading = false;

  @override
  void initState() {
    controller = FaceCameraController(
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        setState(() => _capturedImage = image);
      },
      onFaceDetected: (Face? face) {
        //Do something
      },
    );
    super.initState();
  }


  Future<void> _sendDataToServer() async {
  if (_capturedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('কোনো ছবি ধারণ করা হয়নি', style: TextStyle(fontFamily: 'NikoshBAN'),)),
    );
    return;
  }

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://e-amarseba.com/api/profile-update-by-qr'),
    // Uri.parse('https://beta.e-amarseba.com/api/profile-update-by-qr'),
  );
  setState(() {
    _isUploading = true;
  });

  // Add headers
  request.headers.addAll({
    'Content-Type': 'multipart/form-data',
    // 'Authorization': 'Basic ZGV2ZWxvcGVyOmRldmVsb3Blcl8yMDI0Iy4j' // required for beta
  });

  // Add fields and files
  // request.headers['Authorization'] = 'Basic ZGV2ZWxvcGVyOmRldmVsb3Blcl8yMDI0Iy4j';
  request.fields['username'] = widget.username;
  request.fields['qr_code'] = widget.code;
  request.files.add(await http.MultipartFile.fromPath('profile_photo_path', _capturedImage!.path));

  try {
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    debugPrint('API Code: ${response.statusCode}');
    debugPrint('API Response: $responseData');
    
    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SuccessPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('প্রোফাইল আপডেট করতে ব্যর্থ হয়েছে', style: TextStyle(fontFamily: 'NikoshBAN'))),
      );
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar(content: Text('Error: $e')),
      const SnackBar(content: Text('কিছু ভুল হচ্ছে', style: TextStyle(fontFamily: 'NikoshBAN'),)),
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
                      if (_isUploading)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      
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
                            child: Text(
                              'আবার ছবি নিন',
                              textAlign: TextAlign.center,
                              style: banglaFontStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.deepPurple
                              )
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _sendDataToServer,
                            child: Text(
                              'আপলোড',
                              textAlign: TextAlign.center,
                              style: banglaFontStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.deepPurple
                              ),
                            ),
                          ),
                        ],
                      ),

                      
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
                }
              );
            }),
          ),
    );
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 30),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: banglaFontStyle.copyWith(
              fontSize: 18,
            )),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}