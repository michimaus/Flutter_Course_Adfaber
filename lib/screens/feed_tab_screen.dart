import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/services/database_service.dart';
import 'package:provider/provider.dart';

List<Widget> mockContainers = [
  for (int i = 0; i < 100; i += 1)
    Card(
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      child: Column(
        children: [
          ListTile(
            title: Text("News Number " + i.toString()),
          ),
          Container(
            height: 100,
            width: 500,
            color: Colors.lightBlueAccent,
            child: Text("Image to be added..."),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Some short description coming here"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {},
                child: Text("Comments"),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark_border),
              ),
            ],
          )
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    )
];

class FeedTabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService().getAllNewsQuery(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) => Card(
              clipBehavior: Clip.antiAlias,
              elevation: 10,
              child: Column(
                children: [
                  ListTile(
                    title: Text("News Number " + index.toString()),
                  ),
                  Container(
                    height: 100,
                    width: 500,
                    color: Colors.lightBlueAccent,
                    child: Text("Image to be added..."),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Some short description coming here"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        child: Text("Comments"),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_border),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.bookmark_border),
                      ),
                    ],
                  )
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Container(
            alignment: Alignment.center,
            child: Text("Connection error!"),
          );
        }
        return CircularProgressIndicator();
      },
      // builder: (context, AsyncSnapshot<QuerySnapshot> snapshot),
      // value: DatabaseService().getAllNews(),
      // child: Container(
      //     child: ListView.builder(itemBuilder: itemBuilder)
      // ),
    );
  }
}
