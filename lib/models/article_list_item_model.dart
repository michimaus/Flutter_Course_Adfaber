import 'dart:convert';

ArticleListItemModel articleListItemModelFromJson(String str) => ArticleListItemModel.fromJson(json.decode(str));

String articleListItemModelToJson(ArticleListItemModel data) => json.encode(data.toJson());

class ArticleListItemModel extends Object {
  ArticleListItemModel({
    required this.content,
    required this.imageName,
    required this.short,
    required this.title,
  });

  String content;
  String imageName;
  String short;
  String title;

  factory ArticleListItemModel.fromJson(Map<String, dynamic> json) => ArticleListItemModel(
        content: json["content"],
        imageName: json["imageName"],
        short: json["short"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "imageName": imageName,
        "short": short,
        "title": title,
      };
}
