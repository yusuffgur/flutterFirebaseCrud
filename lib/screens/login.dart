import 'package:flutter/material.dart';
import 'package:flutterFirebaseCrud/screens/home.dart';
import 'package:flutterFirebaseCrud/screens/register.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutterFirebaseCrud/services/auth.dart';
import 'package:flutterFirebaseCrud/shared/constants.dart';
import 'package:flutterFirebaseCrud/shared/loading.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _loginFormKey = GlobalKey<FormState>();
  bool loading = false;
  String error='';
  final AuthService _auth = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("LogIn"),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'email'),
                        controller: _emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Lütfen bir email giriniz';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Lütfen geçerli bir email giriniz';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'password'),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: RaisedButton(
                          child: Text("Login"),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_loginFormKey.currentState.validate()) {
                              setState(() => loading = true);
                              try {
                                dynamic result =
                                    await _auth.logInWithEmailAndPassword(
                                        _emailController.text,
                                        _passwordController.text);
                                if (result != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(),
                                    ),
                                  );
                                } else {
                                  setState(
                                      () => error = 'Check your information');
                                  setState(() => loading = false);
                                }
                              } catch (e) {
                                print('Error Happened!!!: $e');
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
                      Text("Hesabınız yok mu?"),
                      FlatButton(
                        child: Text("Register!"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
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
