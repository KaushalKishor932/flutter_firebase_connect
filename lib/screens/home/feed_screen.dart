import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/firestore_service.dart';
import '../../services/cloudinary_service.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feed")),
      body: StreamBuilder(
        stream: FirestoreService.getPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final postId = docs[index].id;

              return Card(
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    if (data["imageUrl"] != null)
                      Image.network(
                        data["imageUrl"],
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ListTile(
                      title: Text(data["text"] ?? ""),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditDialog(
                              context,
                              postId,
                              data["text"],
                              data["imageUrl"],
                            );
                          } else if (value == 'delete') {
                            _deletePost(context, postId);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text("Edit"),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deletePost(BuildContext context, String postId) async {
    await FirestoreService.deletePost(postId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Post deleted.")),
    );
  }

  void _showEditDialog(
      BuildContext context,
      String postId,
      String? oldText,
      String? oldImageUrl,
      ) {
    final textController = TextEditingController(text: oldText);
    File? newImageFile;
    String? previewImageUrl = oldImageUrl;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Edit Post"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: textController,
                      decoration: InputDecoration(labelText: "Post text"),
                    ),
                    SizedBox(height: 10),
                    if (previewImageUrl != null)
              Image.network(
              previewImageUrl ?? 'https://via.placeholder.com/150',
              height: 150,
              fit: BoxFit.cover,
            ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        if (picked != null) {
                          newImageFile = File(picked.path);

                          // Upload immediately to Cloudinary
                          final newUrl =
                          await CloudinaryService.uploadImage(newImageFile!);

                          setState(() {
                            previewImageUrl = newUrl;
                          });
                        }
                      },
                      child: Text("Pick New Image"),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text("Update"),
                  onPressed: () async {
                    final updateData = {
                      "text": textController.text,
                      "imageUrl": previewImageUrl,
                    };
                    await FirestoreService.updatePost(postId, updateData);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
