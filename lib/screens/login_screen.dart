import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/screens/register_screen.dart';
import 'package:lectia2/services/auth_service.dart';

import '../main.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _auth = AuthService();

  void login(String email, String password, BuildContext context) async {
    User? user;

    if (_formKey.currentState!.validate()) {
      user = await _auth.loginUser(email, password);
    }

    if (user == null) {
    } else {
      MyApp.preferences.setString('userEmail', user.email ?? 'No email!');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

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
        child: Form(
          key: _formKey,
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
                          if (val == null || val.length < 6)
                            return "Password too short. Use at least 6 characters.";
                          else
                            return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                child: Text("Login"),
                onPressed: () {
                  login(emailController.text, passwordController.text, context);
                },
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
      ),
    );
  }
}
