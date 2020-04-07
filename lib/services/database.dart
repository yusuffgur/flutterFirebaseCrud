import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterFirebaseCrud/models/post.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference collection = Firestore.instance.collection('users');

// post list from snapshot
  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post.fromFirestore(doc);
    }).toList();
  }

  // get posts stream
  Stream<List<Post>> get posts {
    return Firestore.instance
        .collectionGroup('posts')
        .snapshots()
        .map(_postListFromSnapshot);
  }

// get individual user posts stream
  Stream<List<Post>> get individualPosts {
    // create user
    return Firestore.instance
        .collection('users')
        .document(uid)
        .collection('posts')
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Future registerUser(String uid, String title, String content) async {
    try {
      return await collection.document(uid).setData({
        "title": title,
        "email": content,
      });
    } catch (e) {
      print('Error Happened!!!: $e');
    }
  }

  Future createPost(String uid, String title, String content) async {
    await collection.document(uid).collection("posts").document().setData({
      "title": title,
      "content": content,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp()
    });
    return uid;
  }

  Future deletePost(String id) async {
    return await collection
        .document(uid)
        .collection('posts')
        .document(id)
        .delete();
  }

  Future editPost(String id, String title, String content) async {
    return await collection
        .document(uid)
        .collection('posts')
        .document(id)
        .setData(
      {
        "title": title,
        "content": content,
        "updatedAt": FieldValue.serverTimestamp(),
      },
    );
  }
}
