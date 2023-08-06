import 'package:flutter/material.dart';
import 'package:vehiclemanager/data/database.dart';
import 'package:vehiclemanager/global/default_pages.dart';
import 'package:vehiclemanager/global/summary.dart';
import 'package:vehiclemanager/global/user.dart';
import 'package:vehiclemanager/logica/memory.dart';
import 'package:vehiclemanager/values/colors.dart';

class SummaryPagePhone extends StatefulWidget {
  const SummaryPagePhone({super.key, required this.title});
  final String title;

  @override
  State<SummaryPagePhone> createState() => _SummaryPagePhone();
}

class _SummaryPagePhone extends State<SummaryPagePhone>
    with TickerProviderStateMixin {
  DefaultPages defaultPages = DefaultPages();
  String message = "";
  bool messageVisibile = false;
  Color messageColor = Colors.red;
  List<Summary> summary = List.empty();
  List<Container> items = List.empty();

  User? mainUser;
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

    database.getSummary().then((value) {
      loading = false;
      setState(() {
        value.sort((a, b) => (a.checkinDate == null || b.checkinDate == null)
            ? 1
            : b.checkinDate!.compareTo(a.checkinDate!));
        items = Summary.listToListItem(value);
        summary = value;
      });
    });

    super.initState();
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
    if (!logedIn) {
      return defaultPages.notLoggedInPage();
    }

    if (loading) {
      return defaultPages.loadingPage();
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
                Expanded(
                    child: ListView(
                  children: items,
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
