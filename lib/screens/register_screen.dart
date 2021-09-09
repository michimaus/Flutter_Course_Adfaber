import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/main.dart';
import 'package:lectia2/screens/login_screen.dart';
import 'package:lectia2/screens/main_screen.dart';
import 'package:lectia2/services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _auth = AuthService();

  void register(String email, String password, BuildContext context) async {
    User? user;

    if (_formKey.currentState!.validate() == true) {
      user = await _auth.registerUser(email, password);

      if (user != null) {
        MyApp.preferences.setString('userEmail', user.email ?? '<no email>');
        MyApp.preferences.setString('userId', user.uid);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
      }
    }
  }

  void goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required field.";
                    } else {
                      return null;
                    }
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
                    if (val == null || val.length < 6)
                      return "Password too short. Use at least 6 characters.";
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
                  register(emailController.text, passwordController.text, context);
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
