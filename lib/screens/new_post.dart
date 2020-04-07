import 'package:flutterFirebaseCrud/screens/home.dart';
import 'package:flutterFirebaseCrud/services/database.dart';
import 'package:flutterFirebaseCrud/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterFirebaseCrud/shared/loading.dart';
import 'package:provider/provider.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final GlobalKey<FormState> _newPostFormKey = GlobalKey<FormState>();
  final titleInputController = TextEditingController();
  final contentInputController = TextEditingController();

  final DatabaseService _db = DatabaseService();
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("NewPost Page"),
            ),
            body: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _newPostFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "Title"),
                        controller: titleInputController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a title.";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "Post content here..."),
                        controller: contentInputController,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: loading
                            ? Center(child: CircularProgressIndicator())
                            : RaisedButton(
                                child: Text("Save Post"),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                onPressed: () async {
                                  if (_newPostFormKey.currentState.validate()) {
                                    try {
                                      setState(() {
                                        loading = true;
                                      });

                                      final user = Provider.of<FirebaseUser>(
                                          context,
                                          listen: false);

                                      dynamic result = await _db.createPost(
                                          user.uid,
                                          titleInputController.text,
                                          contentInputController.text);

                                      if (result != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Home(),
                                          ),
                                        );
                                      } else {
                                        setState(() =>
                                            error = 'Check your information');
                                        setState(() => loading = false);
                                      }
                                    } catch (e) {
                                      print('Error Happened!!!: $e');
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
