/* 
void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
*/ 
// create a custom snackbar widget for all snackbar messages
import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;

  const CustomSnackBar({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return SnackBar(content: Text(message));
  }
}
