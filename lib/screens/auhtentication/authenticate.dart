import 'package:flutter/material.dart';
import 'package:deliveryapp/screens/auhtentication/register.dart';
import 'package:deliveryapp/screens/auhtentication/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    }
      else {
        return Register(toggleView: toggleView);
    }
    }
  }
