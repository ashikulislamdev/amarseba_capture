import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: const Scaffold(
        body: Center(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              Text(
                'ছবি সফলভাবে আপলোড করা হয়েছে',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'NikoshBAN'),
              ),
          
              Text(
                'আমার সেবার সাথে থাকার জন্য ধন্যবাদ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'NikoshBAN'),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}