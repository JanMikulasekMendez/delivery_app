import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/screens/wrapper.dart';
import 'package:deliveryapp/services/database.dart';
import 'package:deliveryapp/shared/constants.dart';
import 'package:deliveryapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

String newUsername = "";

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context, listen: false);
    final DatabaseService _db = DatabaseService(uid: user!.uid);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Settings",
            style: titleStyle,
          ),
          backgroundColor: MyThemes.navbarColor,
        ),
        body: Container(
            decoration: gradientDecoration,
            child: Container(
                margin: EdgeInsets.all(20),
                color: MyThemes.backgroundColorAlt,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        initialValue: globalUser!.username,
                        decoration: textInputDecoration2.copyWith(
                            labelText: "Username"),
                        onChanged: (val) {
                          newUsername = val;
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: MyThemes.buttonColor),
                        onPressed: () async {
                          isOnline = await connectionStatus.checkConnection();
                          if (isOnline) {
                            if (newUsername != "") ;
                            {
                              await _db.updateUsername(username: newUsername);
                            }
                          }
                        },
                        child: Text(
                          'Update Username',
                          style: TextStyle(color: MyThemes.textColor),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
