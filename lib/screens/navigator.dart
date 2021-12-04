import 'dart:async';

import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/screens/contacts/contacts.dart';
import 'package:deliveryapp/screens/settings/settings.dart';
import 'package:deliveryapp/screens/wrapper.dart';
import 'package:deliveryapp/services/connection.dart';
import 'package:deliveryapp/shared/constants.dart';
import 'package:deliveryapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

class NavigatorClass extends StatefulWidget {
  const NavigatorClass({Key? key}) : super(key: key);

  @override
  _NavigatorClassState createState() => _NavigatorClassState();
}

class _NavigatorClassState extends State<NavigatorClass> {

  var _connectionChangeStream;


  @override
  initState() {
    super.initState();

    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOnline = hasConnection;
    });
  }


  List<Icon> icons = [
    Icon(Icons.archive_outlined),
    Icon(Icons.people),
    Icon(Icons.settings)
  ];
  List<String> screens = ["Packages", "Contacts", "Settings"];
  List<Widget> widgets = [Home(),ContactsScreen(),SettingsScreen(),];
  int selectedList = 0;

  void _onButtonTapped(int index) {
    setState(() {

      selectedList = index;
    });
  }

  Widget checkConnection() {
    if(isOnline==false)
      {return LoadingConnecting(loadingReason: "Connecting");}
    else
    {return widgets[selectedList];}
  }


  @override
  Widget build(BuildContext context) {
    globalUser = Provider.of<UserData?>(context);
    print(isOnline);
    return Scaffold (
      resizeToAvoidBottomInset: false,
      body : checkConnection(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: screens[0],
            icon: icons[0],
          ),
          BottomNavigationBarItem(
            label: screens[1],
            icon: icons[1],
          ),
          BottomNavigationBarItem(
            label: screens[2],
            icon: icons[2],
          ),
        ],
          backgroundColor: MyThemes.navbarColor,
          currentIndex: selectedList,
          //New
          onTap: _onButtonTapped,
          selectedFontSize: MyTextSize.tiny,
          selectedIconTheme:
          IconThemeData(color: MyThemes.textColor, size: 30),
          selectedItemColor: MyThemes.textColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold,),
          unselectedFontSize: MyTextSize.micro,
          unselectedIconTheme: IconThemeData(
            color: MyThemes.buttonColor,
          ),
          unselectedItemColor: MyThemes.buttonColor,

      ),
    );
  }
}
