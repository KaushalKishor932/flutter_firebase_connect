class PostModel {
  final String userId;
  final String text;
  final String? imageUrl;

  PostModel({
    required this.userId,
    required this.text,
    this.imageUrl,
  });
}
