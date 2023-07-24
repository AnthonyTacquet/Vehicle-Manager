import 'package:flutter/material.dart';
import 'package:vehiclemanager/data/database.dart';

class HomePagePhone extends StatefulWidget {
  const HomePagePhone({super.key, required this.title});
  final String title;

  @override
  State<HomePagePhone> createState() => _HomePagePhone();
}

class _HomePagePhone extends State<HomePagePhone> {
  int _counter = 0;
  String text = "Loading...";
  final database = MainDatabase();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();

    database.getUser("anthony.tacquet@gmail.com")
    .then((value) {
        setState(() {
          if (value != null){
            final email = value.email;
            final password = value.password;
            final lastName = value.lastName;
            text = "$email $password $lastName";
          }
          else {
            text = "User not found!";
          }
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
