import 'package:flutter/material.dart';
import 'package:vehiclemanager/global/default_pages.dart';
import 'package:vehiclemanager/global/user.dart';
import 'package:vehiclemanager/global/vehicle.dart';

class Summary {
  final DateTime? checkinDate;
  final DateTime checkoutDate;
  final User? user;
  final Vehicle? vehicle;

  const Summary(
    this.checkinDate,
    this.checkoutDate,
    this.user,
    this.vehicle,
  );

  static List<Container> listToListItem(List<Summary> list) {
    List<Container> listItem = List.empty(growable: true);
    for (Summary summary in list) {
      listItem.add(DefaultPages.summaryContainer(summary));
    }
    return listItem;
  }

  User? get guser {
    return user;
  }
}
