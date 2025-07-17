import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _storage = FirebaseStorage.instance;

  static Future<String> uploadProfileImage(String uid, Uint8List data) async {
    final ref = _storage.ref().child("profile_images/$uid.jpg");
    await ref.putData(data);
    return await ref.getDownloadURL();
  }

  static Future<String> uploadPostImage(String uid, Uint8List data) async {
    final ref = _storage.ref().child("posts/${DateTime.now().millisecondsSinceEpoch}_$uid.jpg");
    await ref.putData(data);
    return await ref.getDownloadURL();
  }
}
