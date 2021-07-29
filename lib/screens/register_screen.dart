import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  void register() {}

  void goToLogin() {}

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
                  ),
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
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  controller: passwordCheckController,
                  obscureText: true,
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
                  ),
                ),
              ),

              MaterialButton(
                child: Text("Register"),
                onPressed: register,
                color: Colors.blue,
              ),

              MaterialButton(
                child: Text("Already having an account? Go to Login."),
                onPressed: goToLogin,
              )

            ],
          ),
        ),
      ),
    );
  }
}
