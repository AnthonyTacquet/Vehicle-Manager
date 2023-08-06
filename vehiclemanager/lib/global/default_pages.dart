import 'package:flutter/material.dart';
import 'package:vehiclemanager/global/summary.dart';
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

  static Container summaryContainer(Summary summary) {
    TextStyle bigText = const TextStyle(fontSize: 15);
    TextStyle smallText = const TextStyle(fontSize: 12);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              summary.user!.email,
              style: bigText,
            ),
            Text(
              summary.vehicle!.plate,
              style: bigText,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              summary.checkoutDate.toString(),
              style: smallText,
            ),
            Text(
              summary.checkinDate == null
                  ? "Currently in use!"
                  : summary.checkinDate.toString(),
              style: smallText,
            )
          ],
        )
      ]),
    );
  }
}
