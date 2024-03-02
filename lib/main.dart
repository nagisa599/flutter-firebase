import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/pages/top_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: true, // ここは正しくは!kReleaseModeなど設定してください
      tools: const [
        ...DevicePreview.defaultTools,
        // CustomPlugin(),
      ],
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demagog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      home: const TopPage(title: 'Flutter Demo Home Pafgeff'),
    );
  }
}
