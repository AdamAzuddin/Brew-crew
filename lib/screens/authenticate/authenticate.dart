import 'package:brew_crew/screens/authenticate/sign_in.dart';
import 'package:brew_crew/screens/authenticate/sign_up.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  //const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView(){
    // set reverse of showSignIn
    // if true change to false, vice versa
    setState(() => showSignIn= !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
