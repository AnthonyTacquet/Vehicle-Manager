import 'package:flutter/material.dart';
import 'package:vehiclemanager/data/database.dart';
import 'package:vehiclemanager/global/default_pages.dart';
import 'package:vehiclemanager/global/user.dart';
import 'package:vehiclemanager/logica/memory.dart';
import 'package:vehiclemanager/values/colors.dart';

class LoginPagePhone extends StatefulWidget {
  const LoginPagePhone({super.key, required this.title});
  final String title;

  @override
  State<LoginPagePhone> createState() => _LoginPagePhone();
}

class _LoginPagePhone extends State<LoginPagePhone>
    with TickerProviderStateMixin {
  String message = "";
  DefaultPages defaultPages = DefaultPages();
  var visibility = false;
  var logedIn = false;
  bool loading = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final database = MainDatabase();
  final mem = Memory();

  @override
  void initState() {
    super.initState();
    logedIn = false;

    Future<User?>? user = mem.getUserFromMemory();
    if (user != null) {
      user.then((value) {
        loading = false;
        if (value != null) {
          setState(() {
            logedIn = true;
          });
        } else {
          setState(() {});
        }
      });
    } else {
      loading = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    Future<User?> user = database.login(email, password);

    user.then((value) => {
          if (value == null)
            {
              setState(() {
                message = "Email or password was incorrect!";
                visibility = true;
              })
            }
          else
            {
              mem.writeUserToMemory(value),
              setState(() {
                logedIn = true;
              })
            }
        });
  }

  void logout() {
    Future<User?>? user = mem.getUserFromMemory();
    if (user != null) {
      user.then((value) {
        if (value != null) {
          Future<bool> succes = mem.logoutUser();
          succes.then((value) {
            setState(() {
              logedIn = false;
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return defaultPages.loadingPage();
    }

    if (logedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Login",
            style: TextStyle(color: white),
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
                    TextButton(onPressed: logout, child: const Text("LOG OUT"))
                  ],
                ),
              ),
            )),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: white),
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
                  const Text("LOG IN"),
                  Visibility(
                      visible: visibility,
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.red),
                      )),
                  const Text("Email"),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a search term',
                    ),
                    controller: emailController,
                  ),
                  const Text("Password"),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  TextButton(onPressed: login, child: const Text("LOG IN"))
                ],
              ),
            ),
          )),
    );
  }
}
