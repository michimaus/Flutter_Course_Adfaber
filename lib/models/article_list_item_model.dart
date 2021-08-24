import 'dart:convert';

import 'package:lectia2/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleListItemModel extends Object {
  ArticleListItemModel({
    required this.documentId,
    required this.content,
    required this.imageName,
    required this.short,
    required this.title,
    required this.didLike,
  });

  String documentId;
  String content;
  String imageName;
  String short;
  String title;
  bool didLike;

  factory ArticleListItemModel.fromJson(
      Map<String, dynamic> receivedJson, String documentId) {
    String? currentUserId = MyApp.preferences.getString('userId');
    bool didLike = false;
    List<String> likesOfUsers = List<String>.from(receivedJson['likesOfUsers']);

    if (likesOfUsers.contains(currentUserId)) didLike = true;

    return ArticleListItemModel(
      documentId: documentId,
      content: receivedJson["content"],
      imageName: receivedJson["imageName"],
      short: receivedJson["short"],
      title: receivedJson["title"],
      didLike: didLike,
    );
  }
}
