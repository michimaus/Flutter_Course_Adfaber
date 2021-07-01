import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  void login() {}

  void goToRegister() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.email_rounded),
                  ),
                  Expanded(
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
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.lock),
                  ),
                  Expanded(
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
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: login,
                  child: Text("Login"),
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MaterialButton(
                  onPressed: goToRegister,
                  child: Text("Not having an account yet? Go to Register."),
                )),
          ],
        ),
      ),
    );
  }
}
