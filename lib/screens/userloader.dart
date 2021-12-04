import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/screens/wrapper.dart';
import 'package:deliveryapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigator.dart';

class UserLoader extends StatelessWidget {
  const UserLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globalUser = Provider.of<UserData?>(context);

    //return either home or authenticate widget
    if (globalUser == null) {

      return Loading(loadingReason: "No User Yet",);
    }
    else {
      return NavigatorClass();
    }
  }
}
