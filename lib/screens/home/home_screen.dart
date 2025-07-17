import 'package:flutter/material.dart';
import 'feed_screen.dart';
import 'create_post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SocialBuzz")),
      body: FeedScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CreatePostScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
