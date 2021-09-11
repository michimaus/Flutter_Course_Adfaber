import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/main.dart';
import 'package:lectia2/screens/login_screen.dart';

class ArticleContentScreen extends StatelessWidget {
  logout(BuildContext context) {
    MyApp.preferences.remove('userEmail');
    MyApp.preferences.remove('userId');

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  String imageName;
  String title;
  String content;
  String ownerEmail;

  ArticleContentScreen({
    required this.imageName,
    required this.title,
    required this.content,
    required this.ownerEmail,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(MyApp.preferences.getString('userEmail') ?? '<no email>'),
          actions: [
            MaterialButton(
              child: Text('Logout'),
              onPressed: () {
                logout(context);
              },
            )
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 250,
                      width: 500,
                      child: ClipRRect(
                        child: Image.network(
                          imageName,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8.0),
                      child: MaterialButton(
                        color: Colors.white,
                        shape: CircleBorder(),
                        elevation: 4.0,
                        child: Icon(Icons.arrow_back_ios_rounded),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    this.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    this.ownerEmail,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    this.content,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
