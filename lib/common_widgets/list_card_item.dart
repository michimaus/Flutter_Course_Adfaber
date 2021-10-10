import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/common_widgets/article_content_screen.dart';
import 'package:lectia2/services/database_service.dart';

import 'comments_of_post.dart';

Widget waitingWidget = Container(
  height: 32,
  width: 32,
  child: CircularProgressIndicator(),
);

class CardItem extends StatelessWidget {
  DatabaseService databaseService;

  int index;

  String title;
  String imageName;
  String documentId;
  String short;
  String content;
  String userEmail;
  ValueNotifier likeNotifier;

  List<String> commentsId;

  CardItem({
    required this.databaseService,
    required this.index,
    required this.title,
    required this.imageName,
    required this.documentId,
    required this.short,
    required this.content,
    required this.userEmail,
    required this.likeNotifier,

    required this.commentsId,
  });

  void displayFullPost(BuildContext context, String imageName) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ArticleContentScreen(
              imageName: imageName,
              title: title,
              content: content,
              userEmail: userEmail,
            )));
  }

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        elevation: 10,
        child: Column(
          children: [
            ListTile(
              title: Text(
                this.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            FutureBuilder(
              future: databaseService.getImageUrlByName(this.imageName),
              builder: (context, AsyncSnapshot<dynamic> imageSnapshot) {
                if (imageSnapshot.connectionState == ConnectionState.done) {
                  return InkWell(
                    onTap: () {
                      displayFullPost(context, imageSnapshot.data);
                    },
                    child: Container(
                      height: 220,
                      width: 500,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: ClipRRect(
                        child: Image.network(
                          imageSnapshot.data,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                } else if (imageSnapshot.connectionState == ConnectionState.none) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text("Connection error!"),
                  );
                }

                return waitingWidget;
              },
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(this.short),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CommentsOfPost(
                              databaseService: this.databaseService,
                              userEmail: this.userEmail,
                              title: this.title,
                              articleId: this.documentId,
                              commentsId: this.commentsId,
                            )));
                  },
                  child: Text("Comments"),
                ),
                ValueListenableBuilder(
                  valueListenable: this.likeNotifier,
                  builder: (context, value, Widget? child) => IconButton(
                    onPressed: () {
                      this.likeNotifier.value = !this.likeNotifier.value;
                      databaseService.registerLikeToDocument(this.documentId, this.likeNotifier.value);
                    },
                    icon: this.likeNotifier.value
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
      );
}
