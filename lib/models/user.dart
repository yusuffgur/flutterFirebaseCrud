//import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String email;
  /*final Timestamp createdAt;
  final Timestamp updatedAt;*/

  User({
    this.uid,
    this.name,
    this.email,
    /*this.createdAt, this.updatedAt*/
  });

  /*User.fromFirestore(DocumentSnapshot document)
      : uid = document.documentID,
        name = document['name'],
        email = document['email'],
        createdAt = document['createdAt'],
        updatedAt = document['createdAt'];*/
}
