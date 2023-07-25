import 'package:flutter/material.dart';
import 'package:vehiclemanager/data/database.dart';
import 'package:vehiclemanager/global/user.dart';
import 'package:vehiclemanager/global/vehicle.dart';
import 'package:vehiclemanager/logica/memory.dart';
import 'package:vehiclemanager/values/colors.dart';

class HomePagePhone extends StatefulWidget {
  const HomePagePhone({super.key, required this.title});
  final String title;

  @override
  State<HomePagePhone> createState() => _HomePagePhone();
}

class _HomePagePhone extends State<HomePagePhone>
    with TickerProviderStateMixin {
  String message = "";
  User? mainUser;
  List<DropdownMenuItem<Vehicle>> items = List.empty(growable: true);
  Vehicle selectedItem = Vehicle("", "", 0);
  var logedIn = false;
  bool loading = true;
  late AnimationController controller;
  final database = MainDatabase();
  final mem = Memory();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    controller.repeat(reverse: true);

    Future<User?>? user = mem.getUserFromMemory();
    if (user != null) {
      user.then((value) {
        if (value != null) {
          mainUser = value;
          setState(() {
            logedIn = true;
          });
        }
      });
    }

    Future<List<Vehicle>?> vehicles = database.getVehicles();
    vehicles.then((value) {
      if (value != null) {
        loading = false;
        setState(() {
          items.clear();
          value.map((item) {
            return DropdownMenuItem<Vehicle>(
              value: item,
              child: Text(item.name),
            );
          }).toList();
          selectedItem = value.first;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Container(
          color: darkGrey,
          child: Center(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: white,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    CircularProgressIndicator(
                      value: controller.value,
                    ),
                  ]),
            ),
          ),
        ),
      );
    }

    if (items.isEmpty) {
      items = [
        DropdownMenuItem(
          value: selectedItem,
          child: Text(selectedItem.name),
        )
      ];
    }

    if (!logedIn) {
      return Scaffold(
        body: Container(
          color: darkGrey,
          child: Center(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: white,
              ),
              child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("You are not logged in yet!"),
                  ]),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Container(
        color: darkGrey,
        child: Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Logged in as ${mainUser!.firstName} ${mainUser!.lastName}",
                ),
                DropdownButton<Vehicle>(
                  items: items,
                  onChanged: (newVal) => setState(() => selectedItem = newVal!),
                  value: selectedItem,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
