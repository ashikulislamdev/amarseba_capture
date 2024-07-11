import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              Image.asset('assets/icons/amarseba.png'),
              const SizedBox(height: 60),
              const Text(
                'ছবি সফলভাবে আপলোড করা হয়েছে',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'NikoshBAN'),
              ),
          
              const Text(
                'আমার সেবার সাথে থাকার জন্য ধন্যবাদ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'NikoshBAN'),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: const Text(
                  'বন্ধ করুন',
                  style: TextStyle(fontSize: 22, fontFamily: 'NikoshBAN', color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}