import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vehiclemanager/bottom_navigator.dart';
import 'package:vehiclemanager/values/colors.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAiITRGcfjWmWsZQmNpenthOKdlhMeCmcs",
          appId: "1:588063493707:web:3088c685339bd1bdb007ce",
          messagingSenderId: "588063493707",
          projectId: "vehicle-manager-f4847"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: lightblue),
        useMaterial3: true,
      ),
      home: const BottomNavigationBarExample(),
    );
  }
}
