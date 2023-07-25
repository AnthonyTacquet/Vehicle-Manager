import 'package:flutter/material.dart';
import 'package:vehiclemanager/data/database.dart';
import 'package:vehiclemanager/global/user.dart';
import 'package:vehiclemanager/logica/memory.dart';

class HomePagePhone extends StatefulWidget {
  const HomePagePhone({super.key, required this.title});
  final String title;

  @override
  State<HomePagePhone> createState() => _HomePagePhone();
}

class _HomePagePhone extends State<HomePagePhone> {
  String message = "";
  User? mainUser;
  var logedIn = false;
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!logedIn) {
      return Text("Please login first");
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Logged in as ${mainUser!.firstName} ${mainUser!.lastName}",
            ),
          ],
        ),
      ),
    );
  }
}
