import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lectia2/main.dart';

class CommentModel {
  CommentModel({
    required this.comment,
    required this.commentTime,
    required this.userEmail,
  });

  String comment;
  Timestamp commentTime;
  String userEmail;

  factory CommentModel.fromJson(Map<String, dynamic> receivedJson) {
    return CommentModel(
      comment: receivedJson['comment'],
      commentTime: receivedJson['commentTime'],
      userEmail: receivedJson['userEmail'],
    );
  }
}
