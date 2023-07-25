import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehiclemanager/global/user.dart';

class Memory {
  Future<bool> writeUserToMemory(User user) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    Map<String, dynamic> userString = user.toJson();
    return sharedPref.setString('user', jsonEncode(userString));
  }

  Future<User?>? getUserFromMemory() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? userPref = sharedPref.getString('user');
    if (userPref == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userPref) as Map<String, dynamic>;
    return User.fromJson(userMap);
  }

  Future<bool> logoutUser() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.remove("user");
  }
}
