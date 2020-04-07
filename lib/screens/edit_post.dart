import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterFirebaseCrud/models/post.dart';
import 'package:flutterFirebaseCrud/services/database.dart';
import 'package:flutterFirebaseCrud/shared/constants.dart';
import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  EditPost({Key key, @required this.post}) : super(key: key);
  final Post post;
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final  _postEditFormKey = GlobalKey<FormState>();
  final titleInputController = TextEditingController();
  final contentInputController = TextEditingController();

  bool _isSubmitting = false;

  @override
  initState() {
    titleInputController.text = widget.post.title;
    contentInputController.text = widget.post.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("EditPost"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _postEditFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Title"),
                  controller: titleInputController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Başlık giriniz";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: "Post giriniz"),
                  controller: contentInputController,
                ),
                SizedBox(height: 20),
                _isSubmitting
                    ? Center(child: CircularProgressIndicator())
                    : RaisedButton(
                        child: Text("Update Post"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (_postEditFormKey.currentState.validate()) {
                            try {
                              setState(() {
                                _isSubmitting = true;
                              });
                              await DatabaseService(uid: user.uid).editPost(
                                widget.post.id,
                                titleInputController.text,
                                contentInputController.text,
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              print('Error Happened!!!: $e');
                              setState(() {
                                _isSubmitting = false;
                              });
                            }
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
