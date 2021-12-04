import 'package:deliveryapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:deliveryapp/services/auth.dart';
import 'package:deliveryapp/shared/constants.dart';
import 'package:deliveryapp/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading(loadingReason: "Loading",)
        : Scaffold(
            backgroundColor: MyThemes.backgroundColor,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                backgroundColor: MyThemes.navbarColor,
                elevation: 0.0,
                title: Text("Log-in"),
                actions: <Widget>[
                  TextButton.icon(
                      onPressed: () {
                        widget.toggleView();
                      },
                      icon: Icon(Icons.person, color: MyThemes.buttonColor),
                      label: Text("Register",
                          style: TextStyle(color: MyThemes.buttonColor)))
                ]),
            body: Container(
                decoration: gradientDecoration,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration2.copyWith(labelText: "Email"),
                        validator: (val) => val!.isEmpty ? "Enter email" : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration2.copyWith(labelText: "Password"),
                        validator: (val) =>
                            val!.length < 6 ? "Enter password longer then 6 characters" : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: MyThemes.buttonColor),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            


                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = "Could not log-in with those credentials";
                              });
                            }
                          }
                        },
                        child: Text(
                          "Log-in",
                          style: TextStyle(color: MyThemes.textColor),
                        ),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(error,
                          style: TextStyle(
                              color: MyThemes.errorColor, fontSize: 14.0))
                    ]))));
  }
}

/*
        child: ElevatedButton(
          child: Text("Sign in anon"),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null) {
              print("Error signign in");
            }
            else {
              print("Signed in");
              print(result.uid);
            }
          },
        ),
 */
