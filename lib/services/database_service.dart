import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:lectia2/main.dart';
import 'package:lectia2/models/article_list_item_model.dart';

class DatabaseService {
  final CollectionReference _newsCollection = FirebaseFirestore.instance.collection('news');

  final CollectionReference<ArticleListItemModel> _newsScrollConverter =
      FirebaseFirestore.instance.collection('news').withConverter(
            fromFirestore: (entry, _) => ArticleListItemModel.fromJson(entry.data()!, entry.id),
            toFirestore: (entry, _) => {},
          );

  final FirebaseStorage _storageInstance = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String userId) async {
    String fullFileName = userId + '_' + file.path.split('/').last;

    await _storageInstance.ref('images/' + fullFileName).putFile(file);

    return fullFileName;
  }

  Future<void> addNews(
    String title,
    String short,
    String content,
    String userId,
    String imageName,
  ) async {
    return _newsCollection.doc().set({
      'title': title,
      'short': short,
      'content': content,
      'userId': userId,
      'imageName': imageName,
      'likesOfUsers': [],
      'comments': [],
    });
  }

  Future<QuerySnapshot> getAllNewsQuery() async {
    return await _newsScrollConverter.get();
  }

  Future<dynamic> getImageUrlByName(String imageName) async {
    String fullPath = 'images/' + imageName;
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
}
