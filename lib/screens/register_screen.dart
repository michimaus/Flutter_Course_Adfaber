import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {


  void register() {
    if (_formKey.currentState!.validate()) {
      print("object");
    }
  }

  void goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  controller: emailController,
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
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.red,
                        )),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.red,
                        )),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return "Required field.";
                    else
                      return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  controller: passwordController,
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
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.red,
                        )),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.red,
                        )),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return "Required field.";
                    else
                      return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordCheckController,
                  decoration: InputDecoration(
                    labelText: "Repeat password",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.blue,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.red,
                        )),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.red,
                        )),
                  ),

                  validator: (val) {
                    if (val == passwordController.text)
                      return null;
                    else
                      return "Password doesn't match.";
                  },
                ),
              ),
              MaterialButton(
                child: Text("Register"),
                onPressed: () {
                  register();
                },
                color: Colors.blue,
              ),
              MaterialButton(
                child: Text("Already having an account? Go to Login."),
                onPressed: () {
                  goToLogin(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
