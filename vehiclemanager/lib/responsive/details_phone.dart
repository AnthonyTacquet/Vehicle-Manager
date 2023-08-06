import 'package:flutter/material.dart';
import 'package:vehiclemanager/data/database.dart';
import 'package:vehiclemanager/global/default_pages.dart';
import 'package:vehiclemanager/global/enum/checkin_state.dart';
import 'package:vehiclemanager/global/user.dart';
import 'package:vehiclemanager/global/vehicle.dart';
import 'package:vehiclemanager/logica/memory.dart';
import 'package:vehiclemanager/values/colors.dart';

class DetailsPagePhone extends StatefulWidget {
  const DetailsPagePhone({super.key, required this.title});
  final String title;

  @override
  State<DetailsPagePhone> createState() => _DetailsPagePhone();
}

class _DetailsPagePhone extends State<DetailsPagePhone>
    with TickerProviderStateMixin {
  String message = "";
  CheckinState checkinState = CheckinState.NOT_AVAILABLE;
  DefaultPages defaultPages = DefaultPages();
  bool messageVisibile = false;
  Color messageColor = Colors.red;

  User? mainUser;
  List<DropdownMenuItem<Vehicle>> items = List.empty(growable: true);
  Vehicle selectedItem = const Vehicle("", "", 0);
  var logedIn = false;
  bool loading = true;
  final database = MainDatabase();
  final mem = Memory();

  @override
  void initState() {
    super.initState();

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
            });
          });
        });
      }
    });
  }

  void isVehicleAvailable(Vehicle vehicle) {
    database.isVehicleAvailable(vehicle).then((value) {
      setState(() {
        checkinState = value;
      });
    });
  }

  void changeVehicle(Vehicle? vehicle) {
    if (vehicle == null) return;

    setState(() {
      selectedItem = vehicle;
      isVehicleAvailable(selectedItem);
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
                DropdownButton<Vehicle>(
                  items: items,
                  onChanged: (newVal) => changeVehicle(newVal),
                  value: selectedItem,
                ),
                Text("Name: ${selectedItem.name}"),
                Text("Plate: ${selectedItem.plate}"),
                Text("Seats: ${selectedItem.seats}")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
