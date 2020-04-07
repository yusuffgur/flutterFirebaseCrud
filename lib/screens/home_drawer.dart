import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterFirebaseCrud/screens/home.dart';
import 'package:flutterFirebaseCrud/screens/login.dart';
import 'package:flutterFirebaseCrud/screens/my_posts.dart';
import 'package:flutterFirebaseCrud/screens/register.dart';
import 'package:flutterFirebaseCrud/services/auth.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final bool isAuthenticated = user != null;
    String email = '';
    if (isAuthenticated) {
      email = user.email;
    } else {
      email = 'Anonymous';
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              '$email',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          if (!isAuthenticated) ...[
            InkWell(
              child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Login'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  }),
            ),
            InkWell(
              child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Register'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  }),
            ),
          ],
          if (isAuthenticated) ...[
            InkWell(
              child: ListTile(
                leading: Icon(Icons.sentiment_very_satisfied),
                title: Text('My Posts'),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPosts()),
                  );
                },
              ),
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
