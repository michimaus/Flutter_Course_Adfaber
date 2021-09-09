import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final CollectionReference _newsCollection = FirebaseFirestore.instance.collection('news');

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
    });
  }
}
