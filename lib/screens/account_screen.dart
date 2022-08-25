import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lectia2/common_widgets/list_card_item.dart';
import 'package:lectia2/models/article_list_item_model.dart';
import 'package:lectia2/models/saved_post_ids_model.dart';
import 'package:lectia2/services/database_service.dart';

import '../main.dart';

class AccountScreen extends StatelessWidget {
  static DatabaseService databaseService = DatabaseService();

  static File? _imageFile;

  static String? statingProfilePictureName;

  List<ValueNotifier> likeNotifiers0 = [];
  List<ValueNotifier> savePostNotifiers0 = [];
  List<ValueNotifier> likeNotifiers1 = [];
  List<ValueNotifier> savePostNotifiers1 = [];

  ValueNotifier numberPosts = ValueNotifier(0);
  ValueNotifier numberLikesEarned = ValueNotifier(0);
  ValueNotifier numberSavedPosts = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    likeNotifiers0 = [];
    likeNotifiers1 = [];

    return Container(
      child: FutureBuilder(
        future: Future.wait([databaseService.getNewsOfUserQuery(), databaseService.getAllSavedNewsOfUserQuery()]),
        builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<ArticleListItemModel> entriesTab0 = [];
            List<ArticleListItemModel> entriesTab1 = [];
            print("heeeiii");
            print(snapshot.data);

            if (snapshot.data != null) {
              print("heeeiii");
              entriesTab0 = snapshot.data![0].docs.map((e) => e.data()).toList().cast();
              entriesTab1 = snapshot.data![1].docs.map((e) => e.data()).toList().cast();
            }

            this.numberPosts.value = entriesTab0.length;
            this.numberSavedPosts.value = entriesTab1.length;
            int totalNumberLikes = 0;

            for (ArticleListItemModel entry in entriesTab0) {
              likeNotifiers0.add(ValueNotifier(entry.didLike));
              totalNumberLikes += entry.numberOfLikes;
            }
            this.numberLikesEarned.value = totalNumberLikes;

            for (ArticleListItemModel entry in entriesTab1) {
              likeNotifiers1.add(ValueNotifier(entry.didLike));
            }

            return FutureBuilder(
                future: databaseService.getSavedItemsIds(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  savePostNotifiers0 = [];
                  savePostNotifiers1 = [];
                  List<SavedPostsModel> savedEntriesByUser = [];
                  Set<String> savedEntriesIds = Set();

                  if (snapshot.data != null) {
                    savedEntriesByUser = snapshot.data!.docs.map((e) => e.data()).toList().cast();
                  }

                  if (savedEntriesByUser.length != 0 && savedEntriesByUser[0].savedPosts.length != 0) {
                    savedEntriesIds = savedEntriesByUser[0].savedPosts.toSet();

                    for (int index = 0; index < entriesTab0.length; ++index) {
                      if (savedEntriesIds.contains(entriesTab0[index].documentId)) {
                        savePostNotifiers0.add(ValueNotifier(true));
                      } else {
                        savePostNotifiers0.add(ValueNotifier(false));
                      }
                    }
                  } else {
                    for (int index = 0; index < entriesTab0.length; ++index) {
                      savePostNotifiers0.add(ValueNotifier(false));
                    }
                  }

                  for (int index = 0; index < entriesTab1.length; ++index) {
                    savePostNotifiers1.add(ValueNotifier(true));
                  }

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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        "Number of saved posts: " + this.numberSavedPosts.value.toString(),
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
                            ))),
                      ),
                      Expanded(
                        flex: 3,
                        child: DefaultTabController(
                          length: 2,
                          child: new Scaffold(
                            appBar: new PreferredSize(
                              preferredSize: Size.fromHeight(kToolbarHeight),
                              child: new Container(
                                child: TabBar(
                                  tabs: [
                                    Tab(
                                      icon: Icon(
                                        Icons.list,
                                        color: Colors.black,
                                      ),
                                      child: Text(
                                        'Created Posts',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      icon: Icon(
                                        Icons.bookmark,
                                        color: Colors.black,
                                      ),
                                      child: Text(
                                        'Saved Posts',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            body: TabBarView(
                              children: [
                                Stack(
                                  children: [
                                    ListView.builder(
                                      padding: EdgeInsets.only(top: 24),
                                      itemCount: entriesTab0.length,
                                      itemBuilder: (context, int index) => CardItem(
                                        databaseService: databaseService,
                                        index: index,
                                        title: entriesTab0[index].title,
                                        imageName: entriesTab0[index].imageName,
                                        documentId: entriesTab0[index].documentId,
                                        short: entriesTab0[index].short,
                                        content: entriesTab0[index].content,
                                        userEmail: entriesTab0[index].userEmail,
                                        likeNotifier: likeNotifiers0[index],
                                        savePostNotifier: savePostNotifiers0[index],
                                        commentsId: entriesTab0[index].commentsId,
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
                                // Icon(Icons.directions_transit),
                                Stack(
                                  children: [
                                    ListView.builder(
                                      padding: EdgeInsets.only(top: 24),
                                      itemCount: entriesTab1.length,
                                      itemBuilder: (context, int index) => CardItem(
                                        databaseService: databaseService,
                                        index: index,
                                        title: entriesTab1[index].title,
                                        imageName: entriesTab1[index].imageName,
                                        documentId: entriesTab1[index].documentId,
                                        short: entriesTab1[index].short,
                                        content: entriesTab1[index].content,
                                        userEmail: entriesTab1[index].userEmail,
                                        likeNotifier: likeNotifiers1[index],
                                        savePostNotifier: savePostNotifiers1[index],
                                        commentsId: entriesTab1[index].commentsId,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
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
