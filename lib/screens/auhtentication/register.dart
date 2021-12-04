import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:deliveryapp/services/auth.dart';
import 'package:deliveryapp/shared/constants.dart';
import 'package:deliveryapp/shared/loading.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String username = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading(loadingReason: 'Loading',)
        : Scaffold(
            backgroundColor: MyThemes.backgroundColor,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                backgroundColor: MyThemes.navbarColor,
                elevation: 0.0,
                title: Text("Register"),
                actions: <Widget>[
                  TextButton.icon(
                      onPressed: () {
                        widget.toggleView();
                      },
                      icon: Icon(Icons.person, color: MyThemes.buttonColor),
                      label: Text("Login",
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
                        textInputDecoration2.copyWith(labelText: "Username"),
                        validator: (val) =>
                        val!.isEmpty ? "Enter an username characters" : null,
                        onChanged: (val) {
                          setState(() {
                            username = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration2.copyWith(labelText: "Email"),
                        validator: (val) =>
                            val!.isEmpty ? "Enter an email" : null,
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
                        validator: (val) => val!.length < 6
                            ? "Enter an password 6+ characters"
                            : null,
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
                           await DatabaseService().UserListCollection.where("username", isEqualTo: username).get().then((snapshot) async {
                              if(loading == false){ //snapshot.docs.isNotEmpty TO ENABLE USERNAME CHECK
                                setState(() {
                                  loading = false;
                                  error = "Username already taken";
                                });
                              }
                              else
                                {
                                  dynamic result = await _auth
                                      .registerWithEmailAndPassword(email, password);
                                  if (result == null) {

                                    setState(() {
                                      loading = false;
                                      error = "Could not register with those credentials";

                                    });

                                  }
                                  else {
                                    final user = Provider.of<UserModel?>(context, listen: false);
                                    final DatabaseService _db = DatabaseService(uid: user!.uid);
                                    await _db
                                        .createUserListRecord(username, email);
                                  }
                                }
                            });

                          }
                        },
                        child: Text(
                          "Register",
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
