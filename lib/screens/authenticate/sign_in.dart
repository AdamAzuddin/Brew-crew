// ignore_for_file: avoid_print

import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;

  // ignore: use_key_in_widget_constructors
  const SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    // if loading is true, show loading screen, else show the login form
    return loading? const Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text('Sign in to Brew crew'),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView!();
            },
            icon: const Icon(Icons.person, color: Colors.black),
            label: const Text(
              'Register',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
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
                // Sign in button
                const SizedBox(
                  height: 100.0,
                ),
                ElevatedButton(
                  
                    style: ButtonStyle(
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(color: Colors.white)
                              )
                            )
                          ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _authService
                            .signInWithEmailAndPassword(email, password);
                        if (result == null) {
                          setState(() {
                            error = 'Invalid email or password';
                            loading = false;
                          });
                        }
                      }
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    )
                  ),
                const SizedBox(height: 12.0),
                Text(error,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                  )
                )
              ],
            )),
      ),
    );
  }
}
