import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vehiclemanager/global/user.dart';

class MainDatabase {
  // password : DikkeEzel

  void checkUser(String email, String password) {}

  Future<Database> getDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "database.db");
    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load("resources/database.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    return await openDatabase(path, readOnly: true);
  }

  Future<User?> getUser(String email) async {
    final database = await getDatabase();

    var result =
        await database.rawQuery("SELECT * FROM user WHERE email = ?", [email]);

    print(result);

    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }
}
