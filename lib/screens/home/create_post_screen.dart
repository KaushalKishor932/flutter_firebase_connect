import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../services/cloudinary_service.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  File? _selectedImage;
  bool _loading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);


    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    setState(() {
      _loading = true;
    });

    String? imageUrl;

    if (_selectedImage != null) {
      imageUrl = await CloudinaryService.uploadImage(_selectedImage!);
    }

    final uid = AuthService.currentUser?.uid;
    if (uid != null) {
      await FirestoreService.createPost(
        uid,
        _textController.text,
        imageUrl,
      );
      Navigator.pop(context);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration:
              InputDecoration(labelText: "What's on your mind?"),
            ),
            SizedBox(height: 16),
            _selectedImage != null
                ? Image.file(
              _selectedImage!,
              height: 200,
              fit: BoxFit.cover,
            )
                : SizedBox(),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Pick Image"),
            ),
            ElevatedButton(
              child: Text("Post"),
              onPressed: _uploadPost,
            )
          ],
        ),
      ),
    );
  }
}
