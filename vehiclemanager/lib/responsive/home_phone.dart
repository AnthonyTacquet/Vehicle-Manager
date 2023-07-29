import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:vehiclemanager/data/database.dart';
import 'package:vehiclemanager/global/default_pages.dart';
import 'package:vehiclemanager/global/enum/checkin_state.dart';
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
  DefaultPages defaultPages = DefaultPages();
  String message = "";
  bool messageVisibile = false;
  CheckinState checkinState = CheckinState.NOT_AVAILABLE;
  Color messageColor = Colors.red;

  User? vehicleUser;

  User? mainUser;
  List<DropdownMenuItem<Vehicle>> items = List.empty(growable: true);
  Vehicle selectedItem = const Vehicle("", "", 0);
  var logedIn = false;
  bool loading = true;
  final database = MainDatabase();
  final mem = Memory();

  @override
  void initState() {
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
            items.add(DropdownMenuItem<Vehicle>(
              value: item,
              child: Text(item.name),
            ));
          }).toList();
          selectedItem = value.first;

          database.isVehicleAvailable(selectedItem).then((value) {
            setState(() {
              checkinState = value;

              if (value == CheckinState.NOT_AVAILABLE) {
                database.getUserDrivingVehicle(selectedItem).then((value2) {
                  setState(() {
                    vehicleUser = value2;
                  });
                });
              } else {
                vehicleUser = null;
              }
            });
          });
        });
      }
    });
    super.initState();
  }

  void changeVehicle(Vehicle? vehicle) {
    if (vehicle == null) return;

    setState(() {
      selectedItem = vehicle;
      isVehicleAvailable(selectedItem);
    });
  }

  void isVehicleAvailable(Vehicle vehicle) {
    database.isVehicleAvailable(vehicle).then((value) {
      setState(() {
        checkinState = value;

        if (value == CheckinState.NOT_AVAILABLE) {
          database.getUserDrivingVehicle(vehicle).then((value2) {
            setState(() {
              vehicleUser = value2;
            });
          });
        } else {
          vehicleUser = null;
        }
      });
    });
  }

  void checkIn() {
    database.checkInVehicle(selectedItem).then((value) {
      if (value == null || value == CheckinState.NOT_AVAILABLE) {
        showMessage("An error occured", true);
        return;
      }
      showMessage("Succesfully checked in!", false);

      setState(() {
        checkinState = CheckinState.CURRENT;
      });
    });
  }

  void checkOut() {
    database.checkOutVehicle(selectedItem).then((value) {
      if (value == null || value == CheckinState.NOT_AVAILABLE) {
        showMessage("An error occured", true);
        return;
      }
      showMessage("Succesfully checked out!", false);

      setState(() {
        checkinState = CheckinState.AVAILABLE;
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
  Widget build(BuildContext context) {
    if (loading) {
      return defaultPages.loadingPage();
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
      return defaultPages.notLoggedInPage();
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
                  visible: checkinState != CheckinState.CURRENT,
                  child: DropdownButton<Vehicle>(
                    items: items,
                    onChanged: (newVal) => changeVehicle(newVal),
                    value: selectedItem,
                  ),
                ),
                Visibility(
                    visible: checkinState == CheckinState.NOT_AVAILABLE,
                    child: Text(
                      "This vehicle is currently in use by ${vehicleUser.isNull ? "someone else!" : vehicleUser!.firstName} ${vehicleUser.isNull ? "" : vehicleUser!.lastName}",
                    )),
                Visibility(
                  visible: checkinState == CheckinState.AVAILABLE,
                  child: TextButton(
                      onPressed: checkIn,
                      child: const Text(
                        "CHECK IN",
                        style: TextStyle(color: Colors.green),
                      )),
                ),
                Visibility(
                    visible: checkinState == CheckinState.CURRENT,
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
