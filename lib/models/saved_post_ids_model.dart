class SavedPostsModel {
  SavedPostsModel({
    required this.savedPosts,
  });

  List<String> savedPosts;

  factory SavedPostsModel.fromJson(Map<String, dynamic> receivedJson) {
    return SavedPostsModel(
      savedPosts: List<String>.from(receivedJson['savedPostIds'] as List),
    );
  }
}
