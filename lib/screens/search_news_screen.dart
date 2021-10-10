import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectia2/common_widgets/list_card_item.dart';
import 'package:lectia2/models/article_list_item_model.dart';
import 'package:lectia2/services/database_service.dart';

class SearchNewsScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  final DatabaseService databaseService = DatabaseService();

  List<ValueNotifier> likeNotifiers = [];

  ValueNotifier<String> searchText = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    likeNotifiers = [];

    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
            child: TextField(
              controller: searchController,
              style: TextStyle(
                fontSize: 20,
              ),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                      if (searchText.value != searchController.text) searchText.value = searchController.text;
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (searchText.value != searchController.text) searchText.value = searchController.text;
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: searchText,
                  builder: (context, value, Widget? child) => FutureBuilder(
                    future: databaseService.getAllNewsQuery(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        List<ArticleListItemModel> entries = snapshot.data!.docs.map((e) => e.data()).toList().cast();

                        entries.removeWhere((element) {
                          Set<String> separateWords = element.title.toString().toLowerCase().split(' ').toSet();
                          Set<String> separateParameters = searchText.value.toLowerCase().split(' ').toSet();

                          if (separateWords.intersection(separateParameters).isEmpty) return true;

                          return false;
                        });

                        if (entries.isEmpty) {
                          return Center(
                            child: Text(
                              "Nothing to show...",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          );
                        }

                        for (ArticleListItemModel entry in entries) {
                          likeNotifiers.add(ValueNotifier(entry.didLike));
                        }

                        return ListView.builder(
                            padding: EdgeInsets.only(top: 24),
                            itemCount: entries.length, // Careful here!!
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
                                ));
                      } else if (snapshot.connectionState == ConnectionState.none) {
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
      ),
    );
  }
}
