import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vehiclemanager/global/user.dart';
import 'package:vehiclemanager/global/vehicle.dart';
import 'package:vehiclemanager/logica/memory.dart';

class MainDatabase {
  // password : DikkeEzel
  final Memory memory = Memory();

  void checkUser(String email, String password) {}

  String hashString(String value) {
    var bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }

  Future<Database> getDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    return await openDatabase(
        "/home/anthony/Documents/Git project/Vehicle-Manager/vehiclemanager/resources/database.db",
        readOnly: false);
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

  Future<bool> isVehicleAvailable(Vehicle vehicle) async {
    final database = await getDatabase();

    var results = await database.rawQuery(
        "SELECT * FROM summary WHERE vehicle_plate = ? AND checkin_date IS null ORDER BY datetime(checkout_date) DESC LIMIT 1;",
        [vehicle.plate]);
    if (results.isEmpty) return true;
    return false;
  }

  Future<bool?> checkOutVehicle(Vehicle vehicle) async {
    final database = await getDatabase();
    Future<User?>? user = memory.getUserFromMemory();
    String datetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    if (await isVehicleAvailable(vehicle)) return false;

    if (user == null) return null;
    return await user.then((value) async {
      if (value == null) return null;

      await database.rawQuery(
          "UPDATE summary SET checkin_date = ? WHERE id = (SELECT id FROM summary WHERE vehicle_plate = ? AND user_email = ? AND checkin_date IS NULL ORDER BY datetime(checkout_date) DESC LIMIT 1);",
          [
            datetime,
            vehicle.plate,
            value.email,
          ]);

      return await isVehicleAvailable(vehicle);
    });
  }

  Future<bool?> checkInVehicle(Vehicle vehicle) async {
    final database = await getDatabase();
    String datetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    Future<User?>? user = memory.getUserFromMemory();

    if (!await isVehicleAvailable(vehicle)) return false;

    if (user == null) return null;
    return await user.then((value) async {
      if (value == null) return null;

      await database.rawQuery(
          "INSERT INTO summary (checkout_date, checkin_date, vehicle_plate, user_email) VALUES (?, null, ?, ?);",
          [
            datetime,
            vehicle.plate,
            value.email,
          ]);
      bool val = !await isVehicleAvailable(vehicle);
      return val;
    });
  }

  // INSERT INTO summary (checkout_date, checkin_date, vehicle_plate, user_email)
  // VALUES ('2023-07-3 05:32:37', '2023-07-3 05:32:37', '1XUT187', 'anthony.tacquet@gmail.com');
}
