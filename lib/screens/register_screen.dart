import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {

  void register() {}

  void goToLogin() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "Email",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 1,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 2,
                    color: Colors.blue,
                  )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "Password",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 1,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 2,
                    color: Colors.blue,
                  )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "Repeat password",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 1,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 2,
                    color: Colors.blue,
                  )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MaterialButton(
                color: Colors.blue,
                onPressed: register,
                child: Text("Register"),
              )
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MaterialButton(
                  onPressed: goToLogin,
                  child: Text("Already having an account? Go to Login."),
                )
            ),
          ],
        ),
      ),
    );
  }
}
