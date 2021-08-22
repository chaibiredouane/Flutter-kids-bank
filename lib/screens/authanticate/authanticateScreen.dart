import 'package:first/common/constants.dart';
import 'package:first/common/loading.dart';
import 'package:first/services/authentication.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class AuthanticateScreen extends StatefulWidget {
  const AuthanticateScreen({Key? key}) : super(key: key);
  @override
  _AuthanticateScreenState createState() => _AuthanticateScreenState();
}

class _AuthanticateScreenState extends State<AuthanticateScreen> {
  AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  final photoUrlController = TextEditingController();

  bool showSignIn = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    photoUrlController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      error = '';
      emailController.text = '';
      passwordController.text = '';
      displayNameController.text = '';
      photoUrlController.text = '';
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0,
              title: Text(showSignIn ? 'Sign In' : 'Register'),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () => toggleView(),
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(showSignIn ? 'Register' : 'Sign In',
                      style: TextStyle(color: Colors.white)),
                )
              ],
            ),
            body: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          !showSignIn
                              ? TextFormField(
                                  controller: displayNameController,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'name'),
                                  validator: (text) =>
                                      (text == null || text.isEmpty)
                                          ? 'Enter your full name'
                                          : null,
                                )
                              : Container(),
                          !showSignIn
                              ? SizedBox(
                                  height: 10,
                                )
                              : Container(),
                          TextFormField(
                            controller: emailController,
                            decoration:
                                textInputDecoration.copyWith(hintText: 'email'),
                            validator: (text) => (text == null || text.isEmpty)
                                ? 'Enter an email'
                                : null,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'password'),
                            validator: (value) => (value == null ||
                                    value.length < 6)
                                ? "Enter a password with at least 6 characters"
                                : null,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          !showSignIn
                              ? TextFormField(
                                  controller: photoUrlController,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Photo'),
                                  validator: (text) =>
                                      (text == null || text.isEmpty)
                                          ? 'Enter a photo url'
                                          : null,
                                )
                              : Container(),
                          !showSignIn
                              ? SizedBox(
                                  height: 10,
                                )
                              : Container(),
                          ElevatedButton(
                            child: Text(showSignIn ? "Sign In" : "Register",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);
                                var email = emailController.value.text;
                                var password = passwordController.value.text;
                                var displayName =
                                    displayNameController.value.text;
                                var photoUrl = photoUrlController.value.text;
                                dynamic result = await (showSignIn
                                    ? _auth.signInWithEmailAndPassword(
                                        email, password)
                                    : _auth.registerWithEmailAndPassword(email,
                                        password, displayName, photoUrl));
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                    error = 'Please supply a valid email';
                                  });
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      )),
                )
              ],
            ),
          );
  }
}
