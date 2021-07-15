import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/main.dart';
import 'package:lectia2/screens/login_screen.dart';

class MainScreen extends StatelessWidget {
  logOut(BuildContext context) {
    MyApp.preferences.remove('userEmail');
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Good day " +
            (MyApp.preferences.getString('userEmail') ?? 'to you') +
            '!'),
        actions: [
          MaterialButton(
            child: Text('Logout'),
            onPressed: () {
              logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
