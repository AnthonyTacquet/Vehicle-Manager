import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vehiclemanager/global/user.dart';

class MainDatabase {
  
  // password : DikkeEzel

  void checkUser(String email, String password){

  }

  Future<Database> getDatabase() async{
    WidgetsFlutterBinding.ensureInitialized();    
    var path = join(await getDatabasesPath(), 'app.db');

    await deleteDatabase(path);
    ByteData data = await rootBundle.load("resources/database.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
    return await openDatabase(path);
  }


  Future<User?> getUser(String email) async{
    final database = await getDatabase();
    
    var result = await database.rawQuery("SELECT * FROM user WHERE email = ?", [email]);

    print(result);
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }
}