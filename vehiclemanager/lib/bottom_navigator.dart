import 'package:flutter/material.dart';
import 'package:vehiclemanager/responsive/details_phone.dart';
import 'package:vehiclemanager/responsive/home_phone.dart';
import 'package:vehiclemanager/responsive/login_phone.dart';
import 'package:vehiclemanager/values/colors.dart';

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePagePhone(
      title: "Home Page",
    ),
    LoginPagePhone(title: "Login Page"),
    DetailsPagePhone(title: "Details Page")
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed
        backgroundColor: darkGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
            backgroundColor: white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Details',
            backgroundColor: white,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: white,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
