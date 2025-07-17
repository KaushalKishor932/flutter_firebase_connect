class UserModel {
  final String uid;
  final String email;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    this.photoUrl,
  });
}
