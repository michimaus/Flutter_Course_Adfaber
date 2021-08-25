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

class FeedTabScreen extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();

  List<ValueNotifier> likeNotifiers = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseService.getAllNewsQuery(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print('ceva');

          List<ArticleListItemModel?> entries = snapshot.data!.docs.map((e) => e.data()).toList().cast();

          for (ArticleListItemModel? entry in entries) {
            likeNotifiers.add(ValueNotifier(entry!.didLike));
          }

          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (BuildContext context, int index) => Card(
              clipBehavior: Clip.antiAlias,
              elevation: 10,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      entries[index]!.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: databaseService.getImageUrlByName(entries[index]!.imageName),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> imageSnapshot) {
                      if (imageSnapshot.connectionState == ConnectionState.done) {
                        return Container(
                          height: 220,
                          width: 500,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: ClipRRect(
                            child: Image.network(
                              imageSnapshot.data,
                              // fit: BoxFit.cover,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else if (imageSnapshot.connectionState == ConnectionState.none) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text("Connection error!"),
                        );
                      } else {
                        return Column(
                          children: [
                            waitingWidget,
                          ],
                        );
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
                      ValueListenableBuilder(
                        valueListenable: likeNotifiers[index],
                        builder: (BuildContext context, value, Widget? child) => IconButton(
                          onPressed: () {
                            likeNotifiers[index].value = !likeNotifiers[index].value;
                            databaseService.registerLikeToDocument(
                                entries[index]!.documentId, likeNotifiers[index].value);
                          },
                          icon: likeNotifiers[index].value
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                ),
                        ),
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
    );
  }
}
