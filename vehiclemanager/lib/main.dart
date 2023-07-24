import 'package:flutter/material.dart';
import 'package:vehiclemanager/responsive/home_phone.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main(){
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehcile Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePagePhone(title: 'Flutter Demo Home Page'),
    );
  }
}

