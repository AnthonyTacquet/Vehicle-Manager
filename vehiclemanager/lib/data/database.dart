import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehiclemanager/global/enum/checkin_state.dart';
import 'package:vehiclemanager/global/user.dart';
import 'package:vehiclemanager/global/vehicle.dart';
import 'package:vehiclemanager/logica/memory.dart';

class MainDatabase {
  // password : DikkeEzel
  // password2: DikZwijn
  final Memory memory = Memory();

  void checkUser(String email, String password) {}

  String hashString(String value) {
    var bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }

  Future<FirebaseFirestore> getDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    final db = FirebaseFirestore.instance;
    return db;
  }

  Future<User?> getUser(String email) async {
    final database = await getDatabase();
    email = email.toLowerCase();

    return database
        .collection("user")
        .where("email", isEqualTo: email)
        .limit(1)
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          return User(
              docSnapshot.data()["email"],
              docSnapshot.data()["password"],
              docSnapshot.data()["first_name"],
              docSnapshot.data()["last_name"]);
        }
        return null;
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<User?> getUserDrivingVehicle(Vehicle vehicle) async {
    final database = await getDatabase();

    return await database
        .collection("summary")
        .where("vehicle_plate", isEqualTo: vehicle.plate)
        .where("checkin_date", isNull: true)
        .get()
        .then(
      (querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          var docSnapshot = querySnapshot.docs[0];
          return await getUser(docSnapshot.data()["user_email"]);
        }
        return null;
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<User?> login(String email, String password) async {
    final database = await getDatabase();
    email = email.toLowerCase();

    return database
        .collection("user")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: hashString(password))
        .limit(1)
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          return User(
              docSnapshot.data()["email"],
              docSnapshot.data()["password"],
              docSnapshot.data()["first_name"],
              docSnapshot.data()["last_name"]);
        }
        return null;
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<List<Vehicle>?> getVehicles() async {
    final database = await getDatabase();
    List<Vehicle> vehicles = List.empty(growable: true);

    await database.collection("vehicle").get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          vehicles.add(Vehicle(docSnapshot.data()["name"],
              docSnapshot.data()["plate"], docSnapshot.data()["seats"]));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return vehicles;
  }

  Future<CheckinState> isVehicleAvailable(Vehicle vehicle) async {
    final database = await getDatabase();
    Future<User?>? user = memory.getUserFromMemory();

    if (user == null) return CheckinState.NOT_AVAILABLE;
    return await user.then((value) async {
      if (value == null) return CheckinState.NOT_AVAILABLE;

      CheckinState? state = await database
          .collection("summary")
          .where("vehicle_plate", isEqualTo: vehicle.plate)
          .where("checkin_date", isNull: true)
          .where("user_email", isEqualTo: value.email)
          .get()
          .then(
        (querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) return CheckinState.CURRENT;
          return null;
        },
        onError: (e) => print("Error completing: $e"),
      );

      if (state != null) return state;

      return await database
          .collection("summary")
          .where("vehicle_plate", isEqualTo: vehicle.plate)
          .where("checkin_date", isNull: true)
          .get()
          .then(
        (querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) return CheckinState.NOT_AVAILABLE;
          return CheckinState.AVAILABLE;
        },
        onError: (e) => print("Error completing: $e"),
      );
    });
  }

  Future<CheckinState?> checkOutVehicle(Vehicle vehicle) async {
    final database = await getDatabase();
    Future<User?>? user = memory.getUserFromMemory();
    String datetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    if (await isVehicleAvailable(vehicle) != CheckinState.CURRENT)
      return CheckinState.NOT_AVAILABLE;

    if (user == null) return null;
    return await user.then((value) async {
      if (value == null) return null;

      await database
          .collection("summary")
          .where("vehicle_plate", isEqualTo: vehicle.plate)
          .where("checkin_date", isNull: true)
          .where("user_email", isEqualTo: value.email)
          .limit(1)
          .get()
          .then(
        (querySnapshot) async {
          if (querySnapshot.docs.isEmpty) return null;

          var snap = querySnapshot.docs[0];
          await snap.reference.update({"checkin_date": datetime});
        },
        onError: (e) => print("Error completing: $e"),
      );

      return await isVehicleAvailable(vehicle);
    });
  }

  Future<CheckinState?> checkInVehicle(Vehicle vehicle) async {
    final database = await getDatabase();
    String datetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    Future<User?>? user = memory.getUserFromMemory();

    if (await isVehicleAvailable(vehicle) != CheckinState.AVAILABLE)
      return CheckinState.NOT_AVAILABLE;

    if (user == null) return null;
    return await user.then((value) async {
      if (value == null) return null;

      final data = {
        "checkout_date": datetime,
        "checkin_date": null,
        "vehicle_plate": vehicle.plate,
        "user_email": value.email
      };

      await database.collection("summary").add(data);

      return await isVehicleAvailable(vehicle);
    });
  }

  // INSERT INTO summary (checkout_date, checkin_date, vehicle_plate, user_email)
  // VALUES ('2023-07-3 05:32:37', '2023-07-3 05:32:37', '1XUT187', 'anthony.tacquet@gmail.com');
}
