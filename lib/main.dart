
import 'dart:io';

import 'package:deliveryapp/services/connection.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:deliveryapp/services/auth.dart';
import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();


  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      //_auth.signOut();
    }
  } on SocketException catch (_) {
    print('not connected');
    _auth.signOut();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //await _auth.signOut();
  runApp(MyApp());
}

final AuthService _auth = AuthService();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      child: const MaterialApp(
          home:  Wrapper()
      ),
    );

  }
}

