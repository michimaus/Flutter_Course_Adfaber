import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class DatabaseService {
  final CollectionReference _newsCollection = FirebaseFirestore.instance.collection('news');

  final FirebaseStorage _storageInstance = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String userId) async {
    String fullFileName =
        userId + '_' + (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString() + '_' + file.path.split('/').last;

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
      'short': short,
      'content': content,
      'title': title,
      'owner': userId,
      'imageName': imageName,
    });
  }
}
//
// class UploadingImageToFirebaseStorage extends StatefulWidget {
//   @override
//   _UploadingImageToFirebaseStorageState createState() =>
//       // TODO: implement createState
//       _UploadingImageToFirebaseStorageState();
// }
//
// class _UploadingImageToFirebaseStorageState
//     extends State<UploadingImageToFirebaseStorage> {
//   @override
//   Widget build(BuildContext context) {
//
//   }
//
// }
