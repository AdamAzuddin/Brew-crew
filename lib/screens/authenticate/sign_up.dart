import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

import 'package:brew_crew/services/auth.dart';

class Register extends StatefulWidget {
  final Function? toggleView;

  // ignore: use_key_in_widget_constructors
  const Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  TextEditingController textEditingController = TextEditingController();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text('Sign up to Brew crew'),
              actions: [
                TextButton.icon(
                    onPressed: () {
                      widget.toggleView!();
                    },
                    icon: const Icon(Icons.person, color: Colors.black),
                    label: const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Username/email
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Email',
                        ),
                        validator: (val) {
                          if (val != null && val.isEmpty) {
                            return 'Enter an email';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      // Password
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Password',
                        ),
                        validator: (val) {
                          if (val != null && val.length < 6) {
                            return 'Enter a password 6+ char length';
                          }
                          return null;
                        },
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),

                      // Confirm Password
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: textEditingController,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Confirm Password'),
                        obscureText: true,
                      ),
                      // Sign in button
                      const SizedBox(
                        height: 50.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          confirmPassword = textEditingController.text;
                          if (confirmPassword == password) {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _authService
                                  .registerWithEmailAndPassword(
                                      email, password);

                              if (result == null) {
                                setState(() {
                                  error = 'Please supply a valid email';
                                  loading = false;
                                });
                              }
                            }
                          } else {
                            setState(() {
                              error =
                                  'Password and confirm password doesn\'t match';
                              textEditingController.clear();
                            });
                          }
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14.0,
                          ))
                    ],
                  )),
            ),
          );
  }
}
