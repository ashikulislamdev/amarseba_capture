import 'package:flutter/material.dart';
import 'package:e_amarseba_verify/screens/face_verify.dart';
import 'package:e_amarseba_verify/screens/scanner_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/face-verify') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return FaceVerifyScreen(
                username: args['username']!,
                code: args['code']!,
              );
            },
          );
        }

        // Add more routes here as needed
        // Default route (home)
        return MaterialPageRoute(builder: (context) => const QRViewExample());
      },
    );
  }
}
