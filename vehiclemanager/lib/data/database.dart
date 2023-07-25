import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vehiclemanager/global/user.dart';
import 'package:vehiclemanager/global/vehicle.dart';

class MainDatabase {
  // password : DikkeEzel

  void checkUser(String email, String password) {}

  String hashString(String value) {
    var bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }

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

    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  Future<User?> login(String email, String password) async {
    final database = await getDatabase();

    var result = await database.rawQuery(
        "SELECT * FROM user WHERE email = ? AND password = ?;",
        [email, hashString(password)]);

    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  Future<List<Vehicle>?> getVehicles() async {
    final database = await getDatabase();
    List<Vehicle> vehicles = List.empty(growable: true);

    var results = await database.rawQuery("SELECT * FROM vehicle;");

    if (results.isEmpty) return null;

    for (int i = 0; i < results.length; i++) {
      vehicles.add(Vehicle.fromMap(results[i]));
    }
    return vehicles;
  }
}
