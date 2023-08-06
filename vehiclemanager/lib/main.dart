import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vehiclemanager/bottom_navigator.dart';
import 'package:vehiclemanager/values/colors.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAiITRGcfjWmWsZQmNpenthOKdlhMeCmcs",
          appId: "1:588063493707:web:3088c685339bd1bdb007ce",
          messagingSenderId: "588063493707",
          projectId: "vehicle-manager-f4847"));

  //final fcmToken = await FirebaseMessaging.instance.getToken(
  //  vapidKey:
  //    "BI3e8bxYfM5pF_T5FKXRCQdrsYMWa-iHhlqXt2ImjcIlkFS6n1orWwxTCCoIRviUI7GsGUSlLWiULuds4Qu");

  //FirebaseMessaging.instance.subscribeToTopic('TEST');

  //FirebaseMessaging.instance.unsubscribeFromTopic('TopicToListen');

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
