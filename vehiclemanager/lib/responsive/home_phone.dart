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
  bool messageVisibile = false;
  Color messageColor = Colors.red;

  bool checkedIn = false;

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

          database.isVehicleAvailable(selectedItem).then((value) {
            setState(() {
              checkedIn = !value;
            });
          });
        });
      }
    });
  }

  void isVehicleAvailable(Vehicle vehicle) {
    database.isVehicleAvailable(vehicle).then((value) {
      setState(() {
        checkedIn = value;
      });
    });
  }

  void checkIn() {
    database.checkInVehicle(selectedItem).then((value) {
      if (value == null || !value) {
        showMessage("An error occured", true);
        return;
      }
      showMessage("Succesfully checked in!", false);

      setState(() {
        checkedIn = true;
      });
    });
  }

  void checkOut() {
    database.checkOutVehicle(selectedItem).then((value) {
      if (value == null || !value) {
        showMessage("An error occured", true);
        return;
      }
      showMessage("Succesfully checked out!", false);

      setState(() {
        checkedIn = false;
      });
    });
  }

  void showMessage(String message, bool error) {
    setState(() {
      if (error) {
        messageColor = Colors.red;
      } else {
        messageColor = Colors.green;
      }
      this.message = message;
      messageVisibile = true;
    });
  }

  void hideMessage() {
    setState(() {
      message = "";
      messageVisibile = false;
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
      appBar: AppBar(
        title: Text(
          "Logged in as ${mainUser!.firstName} ${mainUser!.lastName}",
          style: const TextStyle(color: white),
        ),
        backgroundColor: darkGrey,
      ),
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
                Visibility(
                    visible: messageVisibile,
                    child: Text(
                      message,
                      style: TextStyle(color: messageColor),
                    )),
                Visibility(
                  visible: !checkedIn,
                  child: DropdownButton<Vehicle>(
                    items: items,
                    onChanged: (newVal) =>
                        setState(() => selectedItem = newVal!),
                    value: selectedItem,
                  ),
                ),
                Visibility(
                  visible: !checkedIn,
                  child: TextButton(
                      onPressed: checkIn,
                      child: const Text(
                        "CHECK IN",
                        style: TextStyle(color: Colors.green),
                      )),
                ),
                Visibility(
                    visible: checkedIn,
                    child: TextButton(
                        onPressed: checkOut,
                        child: const Text(
                          "CHECK OUT",
                          style: TextStyle(color: Colors.red),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
