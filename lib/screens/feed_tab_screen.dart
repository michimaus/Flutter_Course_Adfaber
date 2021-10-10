import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/common_widgets/list_card_item.dart';
import 'package:lectia2/models/article_list_item_model.dart';
import 'package:lectia2/services/database_service.dart';

class FeedTabScreen extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();

  List<ValueNotifier> likeNotifiers = [];

  @override
  Widget build(BuildContext context) {
    likeNotifiers = [];

    return FutureBuilder(
      future: databaseService.getAllNewsQuery(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<ArticleListItemModel> entries = snapshot.data!.docs.map((e) => e.data()).toList().cast();

          for (ArticleListItemModel entry in entries) {
            likeNotifiers.add(ValueNotifier(entry.didLike));
          }

          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, int index) => CardItem(
                    databaseService: databaseService,
                    index: index,
                    title: entries[index].title,
                    imageName: entries[index].imageName,
                    documentId: entries[index].documentId,
                    short: entries[index].short,
                    content: entries[index].content,
                    userEmail: entries[index].userEmail,
                    likeNotifier: likeNotifiers[index],
                    commentsId: entries[index].commentsId,
                  ));
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Container(
            alignment: Alignment.center,
            child: Text("Connection error!"),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            waitingWidget,
          ],
        );
      },
    );
  }
}
