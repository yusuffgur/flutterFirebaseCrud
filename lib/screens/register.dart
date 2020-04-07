import 'package:flutter/material.dart';
import 'package:flutterFirebaseCrud/screens/home.dart';
import 'package:flutterFirebaseCrud/screens/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutterFirebaseCrud/services/auth.dart';
import 'package:flutterFirebaseCrud/shared/constants.dart';
import 'package:flutterFirebaseCrud/shared/loading.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _registerFormKey = GlobalKey<FormState>();
  bool loading = false;
  String error='';
  final AuthService _auth = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Register"),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _registerFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'name'),
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter name.";
                          }
                          return null;
                        },
                      ),
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
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'confirm password'),
                        obscureText: true,
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Password is not matching';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: RaisedButton(
                          child: Text("Register"),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_registerFormKey.currentState.validate()) {
                              setState(() => loading = true);
                              try {
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        _nameController.text,
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
                      Text("Hesabınız var mı?"),
                      FlatButton(
                        child: Text("Login!"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LogIn()),
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
