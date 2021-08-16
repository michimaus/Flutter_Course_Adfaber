import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/models/article_list_item_model.dart';
import 'package:lectia2/services/database_service.dart';

Widget waitingWidget = Container(
  height: 32,
  width: 32,
  child: CircularProgressIndicator(),
);

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
  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseService.getAllNewsQuery(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print('ceva');

          List<ArticleListItemModel?> entries = snapshot.data!.docs.map((e) => e.data()).toList().cast();

          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (BuildContext context, int index) => Card(
              clipBehavior: Clip.antiAlias,
              elevation: 10,
              child: Column(
                children: [
                  ListTile(
                    title: Text(entries[index]!.title),
                  ),
                  FutureBuilder(
                    future: databaseService.getImageUrlByName(entries[index]!.imageName),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> imageSnapshot) {
                      if (imageSnapshot.connectionState == ConnectionState.done) {
                        return Container(
                          height: 100,
                          width: 500,
                          color: Colors.lightBlueAccent,
                          child: ClipRRect(
                            child: Image.network(imageSnapshot.data),
                          ),
                        );
                      } else if (imageSnapshot.connectionState == ConnectionState.none) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text("Connection error!"),
                        );
                      } else {
                        return waitingWidget;
                      }
                    },
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(entries[index]!.short),
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
        return Container(
          child: waitingWidget,
        );
      },
      // builder: (context, AsyncSnapshot<QuerySnapshot> snapshot),
      // value: DatabaseService().getAllNews(),
      // child: Container(
      //     child: ListView.builder(itemBuilder: itemBuilder)
      // ),
    );
  }
}
