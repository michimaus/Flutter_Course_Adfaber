import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lectia2/common_widgets/list_card_item.dart';
import 'package:lectia2/models/article_list_item_model.dart';
import 'package:lectia2/services/database_service.dart';

import '../main.dart';

class AccountScreen extends StatelessWidget {
  static DatabaseService databaseService = DatabaseService();

  static File? _imageFile;

  static String? statingProfilePictureName;

  List<ValueNotifier> likeNotifiers = [];

  ValueNotifier numberPosts = ValueNotifier(0);
  ValueNotifier numberLikesEarned = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: databaseService.getNewsOfUserQuery(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<ArticleListItemModel> entries = [];

            if (snapshot.data != null) {
              entries = snapshot.data!.docs.map((e) => e.data()).toList().cast();
            }

            this.numberPosts.value = entries.length;
            int totalNumberLikes = 0;

            for (ArticleListItemModel entry in entries) {
              likeNotifiers.add(ValueNotifier(entry.didLike));
              totalNumberLikes += entry.numberOfLikes;
            }
            this.numberLikesEarned.value = totalNumberLikes;

            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(24.0),
                          child: FutureBuilder(
                            future: databaseService.getProfileUrlByName(MyApp.preferences.getString('userId')!),
                            builder: (context, AsyncSnapshot<dynamic> imageSnapshot) {
                              if (imageSnapshot.connectionState == ConnectionState.done) {
                                statingProfilePictureName = imageSnapshot.data;
                                _imageFile = null;
                                return ImageLoader();
                              } else if (imageSnapshot.connectionState == ConnectionState.none) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: Text("Connection error!"),
                                );
                              }

                              return Center(
                                child: waitingWidget,
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Number of posts: " + this.numberPosts.value.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Number of likes earned: " + this.numberLikesEarned.value.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.withOpacity(0.5),
                          )
                      )
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.only(top: 24),
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, int index) => CardItem(
                          databaseService: databaseService,
                          index: index,
                          title: entries[index].title,
                          imageName: entries[index].imageName,
                          documentId: entries[index].documentId,
                          short: entries[index].short,
                          content: entries[index].content,
                          userEmail: entries[index].userEmail,
                          likeNotifier: likeNotifiers[index],
                          commentsId: entries[index].commentsId,
                        ),
                      ),
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // tileMode: TileMode.mirror,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Container(
              alignment: Alignment.center,
              child: Text("Connection error!"),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              waitingWidget,
            ],
          );
        },
      ),
    );
  }
}

class ImageLoader extends StatefulWidget {
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  File? _imageFile;
  final picker = ImagePicker();

  void makeImagePicking() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    _imageFile = File(pickedFile!.path);
    AccountScreen._imageFile = _imageFile!;
    AccountScreen.databaseService
        .uploadProfilePicture(AccountScreen._imageFile!, MyApp.preferences.getString('userId')!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AccountScreen._imageFile == null && AccountScreen.statingProfilePictureName == null
          ? IconButton(
              onPressed: () async {
                makeImagePicking();
              },
              icon: Icon(Icons.add_photo_alternate_outlined),
            )
          : InkWell(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AccountScreen._imageFile != null
                      ? Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          AccountScreen.statingProfilePictureName!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              onLongPress: () {
                if (_imageFile == null && AccountScreen.statingProfilePictureName == null) {
                  return;
                }
                makeImagePicking();
              },
            ),
    );
  }
}
