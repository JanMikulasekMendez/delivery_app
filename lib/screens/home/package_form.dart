import 'package:flutter/material.dart';
import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/shared/constants.dart';
import 'package:provider/provider.dart';

class PackageForm extends StatefulWidget {
  const PackageForm({Key? key}) : super(key: key);

  @override
  _PackageFormState createState() => _PackageFormState();
}

class _PackageFormState extends State<PackageForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  bool? _currentCaffeine;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

            return Container(
              color: MyThemes.backgroundColorAlt,
              child: Form(
                key: _formKey,
                child: Column(children: [

                  ]
              ),
              ),
            );
          }

}
