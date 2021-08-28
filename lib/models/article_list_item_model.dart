import 'package:lectia2/main.dart';

class ArticleListItemModel {
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

  factory ArticleListItemModel.fromJson(Map<String, dynamic> receivedJson, String documentId) {

    String? currentUserId = MyApp.preferences.getString('userId');
    bool didLikeCurrent = false;
    List<String> likesOfUsers = List<String>.from(receivedJson['likesOfUsers']);

    if (likesOfUsers.contains(currentUserId)) didLikeCurrent = true;

    return ArticleListItemModel(
      documentId: documentId,
      content: receivedJson['content'],
      imageName: receivedJson['imageName'],
      short: receivedJson['short'],
      title: receivedJson['title'],
      didLike: didLikeCurrent,
    );
  }
}
