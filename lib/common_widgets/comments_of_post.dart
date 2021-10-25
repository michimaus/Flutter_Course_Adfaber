import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/models/comment_model.dart';
import 'package:lectia2/screens/login_screen.dart';
import 'package:lectia2/services/database_service.dart';

import '../main.dart';
import 'list_card_item.dart';

class CommentsOfPost extends StatelessWidget {
  logout(BuildContext context) {
    MyApp.preferences.remove('userEmail');
    MyApp.preferences.remove('userId');

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  final TextEditingController commentController = TextEditingController();

  ValueNotifier<int> commentsNotifier = ValueNotifier(0);

  DatabaseService databaseService;

  String title;
  String userEmail;
  String articleId;
  List<String> commentsId;

  CommentsOfPost({
    required this.databaseService,
    required this.title,
    required this.userEmail,
    required this.articleId,
    required this.commentsId,
  });

  @override
  Widget build(BuildContext context) {
    print('building comments');
    return Scaffold(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
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
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              this.userEmail,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                this.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: commentsNotifier,
                              builder: (BuildContext context, value, Widget? child) => FutureBuilder(
                                  future: databaseService.getAllCommentsOfArticle(this.commentsId),
                                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      List<CommentModel> entries = [];

                                      if (snapshot.data != null) {
                                        entries = snapshot.data!.docs.map((e) => e.data()).toList().cast();
                                      }

                                      if (entries.isEmpty) {
                                        return Container(
                                          alignment: Alignment.center,
                                          child: Text("No comments to show!"),
                                        );
                                      }

                                      entries.sort((a, b) => b.commentTime.compareTo(a.commentTime));

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: entries
                                            .map(
                                              (entry) => Padding(
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      entry.userEmail,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      entry.comment,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.black.withOpacity(0.1),
                                                      width: double.maxFinite,
                                                      child: Text(
                                                        entry.commentTime.toDate().toString().substring(0, 16),
                                                        textAlign: TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      );
                                    } else if (snapshot.connectionState == ConnectionState.none) {
                                      return Container(
                                        alignment: Alignment.center,
                                        child: Text("Connection error!"),
                                      );
                                    }

                                    return Center(
                                      child: waitingWidget,
                                    );
                                  }),
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 16))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            // tileMode: TileMode.mirror,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: commentController,
                maxLength: 255,
                maxLines: null,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();

                        if (commentController.text == '') return;

                        await databaseService.addComment(
                          MyApp.preferences.getString('userId')!,
                          MyApp.preferences.getString('userEmail')!,
                          commentController.text,
                          this.articleId,
                        );
                        commentController.text = '';
                        commentsNotifier.value += 1;
                      }
                    },
                  ),
                ),
                onSubmitted: (value) async {
                  if (commentController.text == '') return;

                  await databaseService.addComment(
                    MyApp.preferences.getString('userId')!,
                    MyApp.preferences.getString('userEmail')!,
                    commentController.text,
                    this.articleId,
                  );
                  commentController.text = '';
                  commentsNotifier.value += 1;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
