import 'dart:convert';
import 'package:e_amarseba_verify/screens/face_verify.dart';
import 'package:e_amarseba_verify/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isFlashOn = false;
  bool isFrontCamera = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF008645),
              ),
              child: Text(
                'অপশনসমূহ',
                style: banglaFontStyle.copyWith(fontSize: 28),
              ),
            ),
            
            ListTile(
              title: Text('প্রাইভেসি পলিসি', style: banglaFontStyle.copyWith(color: Colors.black, fontSize: 20),),
              onTap: () {
                // alert dialog to show the privacy policy
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('প্রাইভেসি পলিসি', style: banglaFontStyle.copyWith(color: Colors.black, fontSize: 24), textAlign: TextAlign.center,),
                      content: Text('এই গোপনীয়তা নীতি বর্ণনা করে কিভাবে e-amarseba.com ওয়েবসাইট এবং সম্পর্কিত অ্যাপ্লিকেশন (“সাইট”, “আমরা” বা “আমাদের”) এই সাইটের মাধ্যমে আমরা যে ব্যক্তিগত তথ্য সংগ্রহ করি তা সংগ্রহ, ব্যবহার, শেয়ার এবং সুরক্ষা করে। এই নীতিটি আমাদের মোবাইল অ্যাপ্লিকেশন ও ওয়েবসাইটের ক্ষেত্রেও প্রযোজ্য যা আমরা আমাদের সেবা এবং সাইটের টিম নির্দিষ্ট পৃষ্ঠাগুলির সাথে ব্যবহারের জন্য প্রদান করি। এই সাইট ব্যবহার করে আপনি এই গোপনীয়তা নীতি সাথে সম্মত হন।', style: banglaFontStyle.copyWith(color: Colors.black), textAlign: TextAlign.justify,),
                      actions: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF008645)),
                            onPressed: () => Navigator.of(context).pop(), 
                            child: Text('বন্ধ করুন', style: banglaFontStyle.copyWith(fontSize: 20),)
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text('এপ্লিকেশন সম্পর্কে', style: banglaFontStyle.copyWith(color: Colors.black, fontSize: 20),),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('এপ্লিকেশন সম্পর্কে', style: banglaFontStyle.copyWith(color: Colors.black, fontSize: 24), textAlign: TextAlign.center,),
                      content: Text('আপনি যদি “আমার সেবা” (www.e-amarseba.com) নামক ওয়েবসাইটের ব্যবহারকারী হয়ে থাকেন তাহলে ইউজার প্রোফাইল ছবি আপলোড করতে চাইলে এই এ্যাপটি ব্যবহার করতে হবে। কারণ আমার সেবার প্রোফাইলে পুরাতন কোন ছবিকে প্রোফাইল ছবি হিসেবে ব্যবহার করা যাবেনা। এমনকি ছবির স্থানে নিজের ছবি ছাড়া অন্য কোন বস্তু বা ডিজাইন ব্যবহার করা যাবেনা।', style: banglaFontStyle.copyWith(color: Colors.black), textAlign: TextAlign.justify,),
                      actions: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF008645), elevation: 3,),
                            onPressed: () => Navigator.of(context).pop(), 
                            child: Text('বন্ধ করুন', style: banglaFontStyle.copyWith(fontSize: 20),)
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF008645),
        title: const Text('Live Image', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: () {
                // open the drawer
                _scaffoldKey.currentState?.openDrawer();
                // _scaffoldKey.currentState!.openDrawer();
              },
              child: const Icon(Icons.more_vert, color: Colors.white, size: 25,),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(flex: 5, child: _buildQrView(context)),
          // const Expanded(flex: 5, child: Center(child: Text("Flutter app"),)),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('দয়া করে e-amarseba.com থেকে QR Code স্ক্যান করুন', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'NikoshBAN')),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await controller?.toggleFlash();
                            bool? flashStatus = await controller?.getFlashStatus();
                            setState(() {
                              isFlashOn = flashStatus ?? false;
                            });
                          },
                          child: CircleAvatar(
                            child: Icon(
                              isFlashOn ? Icons.flash_on : Icons.flash_off,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await controller?.flipCamera();
                            var cameraInfo = await controller?.getCameraInfo();
                            setState(() {
                              isFrontCamera = cameraInfo == CameraFacing.front;
                            });
                          },
                          child: CircleAvatar(
                            child: Icon(
                              isFrontCamera ? Icons.cameraswitch : Icons.cameraswitch_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async{
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        try {
          final data = jsonDecode(result!.code!);
          if (data.containsKey('username') && data.containsKey('code')) {
            controller.dispose(); // Ensure the camera is released
            await Future.delayed(const Duration(milliseconds: 750));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FaceVerifyScreen(
                  username: data['username'],
                  code: data['code'],
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ভুল QR কোড')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ভুল QR কোড ফরম্যাট')),
          );
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
