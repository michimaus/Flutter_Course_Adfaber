import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  void login() {}

  void goToRegister(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.email),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 3,
                          color: Colors.blue,
                        )),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.lock),
                  Expanded(
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 3,
                          color: Colors.blue,
                        )),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              child: Text("Login"),
              onPressed: login,
              color: Colors.blue,
            ),
            MaterialButton(
              child: Text("Not registered yet? Go to Register."),
              onPressed: () {
                goToRegister(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
