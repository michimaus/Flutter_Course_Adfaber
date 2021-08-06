import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lectia2/main.dart';
import 'package:lectia2/screens/main_screen.dart';
import 'package:lectia2/services/database_service.dart';

class AddPostScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController shortController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  DatabaseService databaseService = DatabaseService();

  static late File _imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: ImageLoader(),
            ),
            TextField(
              controller: titleController,
              maxLength: 127,
              maxLines: null,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: shortController,
              maxLength: 255,
              maxLines: null,
              decoration: InputDecoration(
                labelText: "Short description",
              ),
            ),
            TextField(
              controller: contentController,
              maxLength: 65535,
              maxLines: null,
              decoration: InputDecoration(
                labelText: "Full content",
              ),
            ),
            MaterialButton(
              color: Colors.blue,
              child: Text("Post this article"),
              onPressed: () async {
                String imageStorageName =
                    await databaseService.uploadImage(_imageFile, MyApp.preferences.getString("userId")!);

                await databaseService.addNews(titleController.text, shortController.text, contentController.text,
                    MyApp.preferences.getString("userId")!, imageStorageName);

                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ImageLoader extends StatefulWidget {
  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  File? _imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: _imageFile == null
          ? IconButton(
              onPressed: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                _imageFile = File(pickedFile!.path);
                AddPostScreen._imageFile = _imageFile!;

                setState(() {});
              },
              icon: Icon(Icons.add_photo_alternate_outlined),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.file(_imageFile!),
            ),
    );
  }
}
