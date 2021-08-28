import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/main.dart';
import 'package:lectia2/screens/account_screen.dart';
import 'package:lectia2/screens/add_post_screen.dart';
import 'package:lectia2/screens/feed_tab_screen.dart';
import 'package:lectia2/screens/login_screen.dart';
import 'package:lectia2/screens/search_news_screen.dart';

class MainScreen extends StatelessWidget {
  logout(BuildContext context) {
    MyApp.preferences.remove('userEmail');
    MyApp.preferences.remove('userId');

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  int _tabIndex = 0;
  ValueNotifier<int> _tabNotifier = ValueNotifier(0);

  List tabScreens = [
    FeedTabScreen(),
    SearchNewsScreen(),
    AddPostScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          Expanded(
            // child: tabScreens[_tabIndex],
            child: ValueListenableBuilder(
              valueListenable: _tabNotifier,
              builder: (BuildContext context, int value, Widget? child) {
                return tabScreens[value];
              },
            ),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 25,
                currentIndex: _tabIndex,
                onTap: (value) {
                  if (value != _tabIndex) {
                    _tabIndex = value;
                    _tabNotifier.value = _tabIndex;
                    setState(() => {});
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.feed),
                    label: "Feed",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: "Search",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.post_add_rounded),
                    label: "Add new post",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: "Me",
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
