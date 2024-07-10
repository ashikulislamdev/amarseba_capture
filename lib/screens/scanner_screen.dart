import 'dart:convert';
import 'package:e_amarseba_verify/screens/face_verify.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF048B3F),
        title: const Text('Live Capture', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              // open the drawer
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(flex: 5, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (result != null)
                    Text('Data: ${result!.code}')
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('দয়া করে e-amarseba.com থেকে QR Code স্ক্যান করুন', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
            await Future.delayed(const Duration(milliseconds: 100));
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
              const SnackBar(content: Text('Invalid QR code')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid QR code format')),
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
