import 'package:lectia2/main.dart';

class ArticleListItemModel {
  ArticleListItemModel({
    required this.documentId,
    required this.content,
    required this.imageName,
    required this.short,
    required this.title,
    required this.userEmail,
    required this.didLike,
    required this.didSave,
    required this.commentsId,
    required this.numberOfLikes,
  });

  String documentId;
  String content;
  String imageName;
  String short;
  String title;
  String userEmail;
  bool didLike;
  bool didSave;

  List<String> commentsId;

  int numberOfLikes;

  factory ArticleListItemModel.fromJson(Map<String, dynamic> receivedJson, String documentId) {
    String? currentUserId = MyApp.preferences.getString('userId');
    bool didLikeCurrent = false;
    bool didSaveCurrent = false;
    List<String> likesOfUsers = List<String>.from(receivedJson['likesOfUsers']);

    if (likesOfUsers.contains(currentUserId)) didLikeCurrent = true;

    return ArticleListItemModel(
      documentId: documentId,
      content: receivedJson['content'],
      imageName: receivedJson['imageName'],
      short: receivedJson['short'],
      title: receivedJson['title'],
      userEmail: receivedJson['userEmail'],
      commentsId: List<String>.from(receivedJson['comments'] as List),
      didLike: didLikeCurrent,
      didSave: didSaveCurrent,
      numberOfLikes: likesOfUsers.length,
    );
  }
}
