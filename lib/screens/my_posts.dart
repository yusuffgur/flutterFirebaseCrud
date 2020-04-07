import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterFirebaseCrud/models/post.dart';
import 'package:flutterFirebaseCrud/screens/edit_post.dart';
import 'package:flutterFirebaseCrud/screens/new_post.dart';
import 'package:flutterFirebaseCrud/screens/show_posts.dart';
import 'package:flutterFirebaseCrud/services/database.dart';
import 'package:flutterFirebaseCrud/shared/loading.dart';
import 'package:provider/provider.dart';

class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("MyPosts Page"),
      ),
      body: StreamBuilder<List<Post>>(
        stream: DatabaseService(uid: user.uid).individualPosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post> posts = snapshot.data;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    posts[index].title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(posts[index].content),
                  trailing: PopupMenuButton(
                    onSelected: (result) async {
                      final type = result["type"];
                      final post = result["value"];
                      switch (type) {
                        case 'edit':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPost(post: posts[index]),
                            ),
                          );
                          break;
                        case 'delete':
                          DatabaseService(uid: user.uid).deletePost(post.id);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        value: {"type": "edit", "value": posts[index]},
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: {"type": "delete", "value": posts[index]},
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowPosts(post: posts[index]),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Loading();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPost()),
          );
        },
        tooltip: 'New Post',
        child: Icon(Icons.note_add),
      ),
    );
  }
}
