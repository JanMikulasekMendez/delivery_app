import 'package:deliveryapp/models/package.dart';
import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/services/database.dart';
import 'package:deliveryapp/shared/constants.dart';
import 'package:deliveryapp/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

class PackageScreen extends StatefulWidget {
  PackageScreen({Key? key, this.package, required bool this.editmode})
      : super(key: key);
  Package? package = Package(name: "");

  final bool editmode;

  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  //properties
  String titleText = "New Item";
  double separator_vertical = 20;
  Package package = Package(name: "");

  DateTime currentTime = DateTime.now();
  bool timeSet = false;
  DateTime estimatedAt = DateTime.now();

  //functions
  DateTime? getTime() {
    if (widget.editmode == true || timeSet == true) {
      return estimatedAt;
    }
    return getSoonestDelivery();
  }

  DateTime? getSoonestDelivery() {
    var soonestDelivery = DateTime.now();
    print("Today: ${soonestDelivery.weekday}");

    if (soonestDelivery.weekday == 6) {
      soonestDelivery = DateTime(soonestDelivery.year, soonestDelivery.month,
          soonestDelivery.day + 2, 12);
    }
    ;
    if (soonestDelivery.weekday == 7) {
      soonestDelivery = DateTime(soonestDelivery.year, soonestDelivery.month,
          soonestDelivery.day + 1, 12);
    }
    ;
    soonestDelivery = DateTime(soonestDelivery.year, soonestDelivery.month,
        soonestDelivery.day + 2, 12);
    print("Today: ${soonestDelivery.weekday}");
    estimatedAt = soonestDelivery;
    print("Soonest possible Delivery: $soonestDelivery");
    return estimatedAt;
  }

  @override
  void initState() {
    if (widget.editmode) {
      package = Package(
        id: widget.package!.id,
        name: widget.package!.name,
        estimatedAt: widget.package!.estimatedAt,
        arrivedAt: widget.package!.arrivedAt,
        deliveredBy: widget.package!.deliveredBy,
        address: widget.package!.address,
        paymentMethod: widget.package!.paymentMethod,
        user: widget.package!.user,
        delivered: widget.package!.delivered,
        ownerID: widget.package!.ownerID,
      );
      estimatedAt = DateTime.parse(widget.package!.estimatedAt);
    } else {
      getSoonestDelivery();
      package = Package(name: "", estimatedAt: DateTime.now().toString());
    }
    super.initState();
  }

  // static widgets
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final DatabaseService _db = DatabaseService(uid: user!.uid);

    //dynamic widgets
    Widget showButtons() {
      if (widget.editmode == true) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: MyThemes.backgroundColor,
                    title: const Text('Delete?'),
                    content: const Text('This action can not be undone'),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: MyThemes.buttonColor),
                        onPressed: () => Navigator.pop(context, 'CANCEL'),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: MyThemes.textColor),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: MyThemes.buttonColor),
                        onPressed: () async {
                          await connectionStatus.checkConnection();
                          if (isOnline) {
                            _db.deletePackage(package: package);
                            int count = 0;
                            Navigator.popUntil(context, (route) {
                              return count++ == 2;
                            });
                          }
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: MyThemes.textColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Delete"),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(MyThemes.buttonColor),
              ),
            ),
            SizedBox(
              height: separator_vertical,
            ),
          ],
        );
      } else {
        return SizedBox();
      }
    }

    if (widget.editmode) {
      titleText = "Edit Item";
    }
    String estimatedString =
        "Estimated Delivery : ${estimatedAt.day}.${estimatedAt.month}.${estimatedAt.year} ${DateFormat("Hm").format(estimatedAt)}";

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyThemes.barButtonColor, //change your color here
          ),
          backgroundColor: MyThemes.navbarColor,
          title: Text(
            titleText,
            style: titleStyle,
          ),
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  isOnline = await connectionStatus.checkConnection();
                  if (isOnline) {
                    if (widget.editmode) {
                      await _db.updatePackage(package: package);
                      Navigator.pop(context);
                    } else {
                      if (package.name != "") {
                        package.arrivedAt = DateTime.now().toString();
                        await _db.insertPackage(package: package);
                        Navigator.pop(context);
                      }
                    }
                    ;
                  }
                },
                icon: Icon(Icons.save, color: MyThemes.barButtonColor),
                label: Text("Save",
                    style: TextStyle(color: MyThemes.barButtonColor)))
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          decoration: gradientDecoration,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
              color: MyThemes.backgroundColorAlt,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: package.name,
                    decoration:
                        textInputDecoration2.copyWith(labelText: "Item Name"),
                    onChanged: (val) {
                      package.name = val;
                    },
                  ),
                  SizedBox(
                    height: separator_vertical,
                  ),
                  TextFormField(
                    initialValue: package.deliveredBy,
                    decoration: textInputDecoration2.copyWith(
                        labelText: "Delivered By"),
                    onChanged: (val) {
                      package.deliveredBy = val;
                    },
                  ),
                  SizedBox(
                    height: separator_vertical,
                  ),
                  TextFormField(
                    initialValue: package.address,
                    decoration: textInputDecoration2.copyWith(
                        labelText: "Delivery Adress"),
                    onChanged: (val) {
                      package.address = val;
                    },
                  ),
                  SizedBox(
                    height: separator_vertical,
                  ),
                  TextFormField(
                    initialValue: package.paymentMethod,
                    decoration: textInputDecoration2.copyWith(
                        labelText: "Payment Method"),
                    onChanged: (val) {
                      package.paymentMethod = val;
                    },
                  ),
                  SizedBox(
                    height: separator_vertical,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                theme: DatePickerTheme(
                                  backgroundColor: MyThemes.backgroundColorAlt!,
                                  doneStyle:
                                      TextStyle(color: MyThemes.buttonColor),
                                  cancelStyle:
                                      TextStyle(color: MyThemes.errorColor),
                                ),
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(3000, 1, 1),
                                onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                              setState(() {
                                timeSet = true;
                                estimatedAt = date;
                                package.estimatedAt = estimatedAt.toString();
                                estimatedString =
                                    "Estimated Delivery : ${estimatedAt.day}.${estimatedAt.month}.${estimatedAt.year} ${DateFormat("Hm").format(estimatedAt)}";
                              });
                            }, currentTime: getTime(), locale: LocaleType.en);
                          },
                          child: Text(estimatedString),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(MyThemes.buttonColor),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: separator_vertical,
                  ),
                  showButtons(),
                ],
              ),
            ),
          ),
        ));
  }
}
