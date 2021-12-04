import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/screens/auhtentication/authenticate.dart';
import 'package:deliveryapp/screens/navigator.dart';
import 'package:deliveryapp/screens/userloader.dart';
import 'package:deliveryapp/services/connection.dart';

import 'package:deliveryapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


UserModel? globalAuthUser = UserModel(uid: "globalAuthUser");
UserData? globalUser = UserData(uid: "globalUser");
bool isOnline = true;
ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globalAuthUser = Provider.of<UserModel?>(context);

    //return either home or authenticate widget
    if (globalAuthUser == null) {

      return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),child: Authenticate());
    }
    else {
      print(globalAuthUser!.uid);
      return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),child: StreamProvider<UserData>.value(
          value: DatabaseService(uid: globalAuthUser!.uid).userInfo,
          initialData: UserData(uid: globalAuthUser!.uid),
          //updateShouldNotify: (prev, next) => true,
          child: UserLoader()
      ));
    }
    }
  }


