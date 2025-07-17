import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> saveUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection("users").doc(uid).set(data);
  }

  static Future<void> createPost(String uid, String text, String? imageUrl) async {
    await _firestore.collection("posts").add({
      "userId": uid,
      "text": text,
      "imageUrl": imageUrl,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
  static Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await _firestore.collection("posts").doc(postId).update(data);
  }

  static Future<void> deletePost(String postId) async {
    await _firestore.collection("posts").doc(postId).delete();
  }

}
