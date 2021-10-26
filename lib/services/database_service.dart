import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:lectia2/main.dart';
import 'package:lectia2/models/article_list_item_model.dart';
import 'package:lectia2/models/comment_model.dart';

class DatabaseService {
  final CollectionReference _newsCollection = FirebaseFirestore.instance.collection('news');

  final CollectionReference _commentsCollection = FirebaseFirestore.instance.collection('comments');

  final CollectionReference<ArticleListItemModel> _newsScrollConverter =
      FirebaseFirestore.instance.collection('news').withConverter(
            fromFirestore: (entry, _) => ArticleListItemModel.fromJson(entry.data()!, entry.id),
            toFirestore: (entry, _) => {},
          );

  final CollectionReference<CommentModel> _commentsScrollConverter =
      FirebaseFirestore.instance.collection('comments').withConverter(
            fromFirestore: (entry, _) => CommentModel.fromJson(entry.data()!),
            toFirestore: (entry, _) => {},
          );

  final FirebaseStorage _storageInstance = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String userId) async {
    String fullFileName = userId + '_' + file.path.split('/').last;
    await _storageInstance.ref('images/' + fullFileName).putFile(file);

    return fullFileName;
  }

  Future<void> uploadProfilePicture(File file, String userId) async {
    String fileName = userId;
    await _storageInstance.ref('profile/' + fileName).putFile(file);
  }

  Future<void> addNews(
    String title,
    String short,
    String content,
    String userId,
    String userEmail,
    String imageName,
  ) async {
    return _newsCollection.doc().set({
      'title': title,
      'short': short,
      'content': content,
      'userId': userId,
      'userEmail': userEmail,
      'imageName': imageName,
      'likesOfUsers': [],
      'comments': [],
    });
  }

  Future<void> addComment(
    String userId,
    String userEmail,
    String comment,
    String articleId,
  ) async {
    DocumentReference documentReference = await _commentsCollection.add({
      'userId': userId,
      'userEmail': userEmail,
      'comment': comment,
      'commentTime': FieldValue.serverTimestamp(),
    });

    registerCommentToArticle(documentReference.id, articleId);
  }

  Future<QuerySnapshot> getAllNewsQuery() async {
    return await _newsScrollConverter.get();
  }

  Future<QuerySnapshot> getNewsOfUserQuery() async {
    return await _newsScrollConverter.where('userId', isEqualTo: MyApp.preferences.getString('userId')!).get();
  }

  Future<QuerySnapshot> getAllCommentsOfArticle(List<String> commentsId) async {
    return await _commentsScrollConverter
        // .orderBy("commentTime", descending: true)
        .where(FieldPath.documentId, whereIn: commentsId)
        .get();
  }

  Future<dynamic> getImageUrlByName(String imageName) async {
    String fullPath = 'images/' + imageName;
    return await _storageInstance.ref().child(fullPath).getDownloadURL();
  }

  Future<dynamic> getProfileUrlByName(String imageName) async {
    String fullPath = 'profile/' + imageName;
    return await _storageInstance.ref().child(fullPath).getDownloadURL();
  }

  Future<void> registerLikeToDocument(String documentId, bool didLike) async {
    String? userId = MyApp.preferences.getString('userId');

    if (didLike) {
      _newsCollection.doc(documentId).update({
        'likesOfUsers': FieldValue.arrayUnion([userId]),
      });
    } else {
      _newsCollection.doc(documentId).update({
        'likesOfUsers': FieldValue.arrayRemove([userId]),
      });
    }
  }

  Future<void> registerCommentToArticle(String commentId, String articleId) async {
    _newsCollection.doc(articleId).update({
      'comments': FieldValue.arrayUnion([commentId])
    });
  }
}
