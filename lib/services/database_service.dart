import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:lectia2/models/article_list_item_model.dart';

class DatabaseService {
  final CollectionReference _newsCollection = FirebaseFirestore.instance.collection('news');
  final CollectionReference<ArticleListItemModel> _newsScrollConverter =
      FirebaseFirestore.instance.collection('news').withConverter<ArticleListItemModel>(
            fromFirestore: (entry, _) => ArticleListItemModel.fromJson(entry.data()!),
            toFirestore: (entry, _) => entry.toJson(),
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

      // Added here
      'likesOfUsers': [],
      'comments': [],
    });
  }

  Future<List<ArticleListItemModel>> getAllNews() async {
    List<QueryDocumentSnapshot<ArticleListItemModel>> scrollableNews;
    scrollableNews = await _newsScrollConverter.get().then((value) => value.docs);
    return scrollableNews.map((e) => e.data()).toList();
  }

  Future<QuerySnapshot> getAllNewsQuery() async {
    return await _newsScrollConverter.get();
  }
}
