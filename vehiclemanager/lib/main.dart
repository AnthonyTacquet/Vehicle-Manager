import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vehiclemanager/bottom_navigator.dart';
import 'package:vehiclemanager/values/colors.dart';

main() {
  databaseFactory = databaseFactoryFfi;
  //databaseFactory = databaseFactoryFfiWeb;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehcile Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: lightblue),
        useMaterial3: true,
      ),
      home: const BottomNavigationBarExample(),
    );
  }
}
