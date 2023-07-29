import 'package:flutter/material.dart';
import 'package:vehiclemanager/values/colors.dart';

class DefaultPages {
  Scaffold notLoggedInPage() {
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

  Scaffold loadingPage() {
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
                  SizedBox(height: 30),
                  CircularProgressIndicator(),
                ]),
          ),
        ),
      ),
    );
  }
}
