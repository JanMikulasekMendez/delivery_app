import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/screens/home/package_screen/package_screen.dart';
import 'package:deliveryapp/screens/wrapper.dart';
import 'package:deliveryapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:deliveryapp/models/package.dart';
import 'package:deliveryapp/shared/constants.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyCell extends StatefulWidget {
  const MyCell({Key? key, required this.package}) : super(key: key);
  final Package package;

  @override
  _MyCellState createState() => _MyCellState();
}

class _MyCellState extends State<MyCell> {
  //properties
  Package package = Package(name: "");
  Color iconColor = Colors.red;
  DateTime estimatedAt = DateTime.now();
  DateTime arrivedAt = DateTime.now();

  double cellHeight = 150;
  bool cellExpanded = false;

  @override
  void initState() {
    estimatedAt = DateTime.parse(widget.package.estimatedAt);
    arrivedAt = DateTime.parse(widget.package.arrivedAt);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final DatabaseService _db = DatabaseService(uid: user!.uid);
    //init
    package = widget.package;
    estimatedAt = DateTime.parse(widget.package.estimatedAt);
    arrivedAt = DateTime.parse(widget.package.arrivedAt);
    int estimateTs = estimatedAt.millisecondsSinceEpoch; //
    final String dateString =
        "${estimatedAt.day}.${estimatedAt.month}.${estimatedAt.year} ${DateFormat("Hm").format(estimatedAt)}";
    final String arrivedString =
        "${arrivedAt.day}.${arrivedAt.month}.${arrivedAt.year} ${DateFormat("Hm").format(arrivedAt)}";

    //Dynamic Widgets
    Widget nameLogo() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              CircleAvatar(
                  backgroundColor: MyThemes.navbarColor,
                  radius: 20,
                  child: Icon(
                    Icons.archive_outlined,
                    size: 30,
                    color: iconColor,
                  )),
              SizedBox(height: 5),
              Text(
                "",
                textAlign: TextAlign.center,
              )
            ],
          ),
          Expanded(
              child: Text(
            "${package.name}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          )),
          Column(
            children: [
              CircleAvatar(
                  backgroundColor: MyThemes.navbarColor,
                  radius: 20,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: iconColor,
                  )),
              SizedBox(height: 5),
              Text(
                "${package.user}",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      );
    }

    Widget isDelivered() {
      if (package.delivered == false) {
        return StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 1), (i) => i),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              DateFormat format = DateFormat("mm:ss");
              int now = DateTime.now().millisecondsSinceEpoch;
              Duration remaining = Duration(milliseconds: estimateTs - now);
              Duration remainingDur;
              String addString = "";
              String endString = "";

              if (remaining < Duration(milliseconds: 0)) {
                remainingDur = Duration(milliseconds: now - estimateTs);
                iconColor = Colors.orange[300]!;
                addString = "";
                endString = "late";
              } else {
                remainingDur = remaining;
                iconColor = Colors.green[300]!;
                addString = "";
                endString = "left";
              }
              var remainingDurFix = remainingDur.inHours;
              do {
                if (remainingDurFix >= 24) {
                  remainingDurFix = remainingDurFix - 24;
                }
                ;
              } while (remainingDurFix >= 24);
              var dateString =
                  '$addString ${remainingDur.inDays} days : ${remainingDurFix} Hour(s) & ${format.format(DateTime.fromMillisecondsSinceEpoch(remainingDur.inMilliseconds))} $endString';
              return Column(
                children: [
                  nameLogo(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: iconColor,
                        border: Border.all(
                          color: iconColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    //color: bgColor,
                    alignment: Alignment.center,
                    child: Text(dateString),
                  ),
                ],
              );
            });
      } else {
        iconColor = Colors.blue[300]!;
        return Column(
          children: [
            nameLogo(),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: iconColor,
                  border: Border.all(
                    color: iconColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              //color: bgColor,
              alignment: Alignment.center,
              child: Text("Delivered At : $arrivedString"),
            ),
          ],
        );
      }
    }

    Widget showEdit() {
      if (globalAuthUser!.uid == package.ownerID) {
        return Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    isOnline = await connectionStatus.checkConnection();
                    if (isOnline) {
                      setState(() {
                        cellExpanded = false;
                        cellHeight = 150;
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              PackageScreen(package: package, editmode: true)));
                    }
                  },
                  child: Text("Edit"),
                  style:
                      ElevatedButton.styleFrom(primary: MyThemes.buttonColor),
                ),
              ),
            ],
          ),
        );
      } else {
        return SizedBox();
      }
    }

    //Static Widgets

    Widget isCellExpanded() {
      if (cellExpanded) {
        return Container(
          height: 150.0,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Estimated :"),
                        Text("Address :"),
                        Text("Payment Method : "),
                        Text("Delivered By : "),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${dateString}",
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text("${package.address}",
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text("${package.paymentMethod}",
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text("${package.deliveredBy}",
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  )
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  showEdit(),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        isOnline = await connectionStatus.checkConnection();
                        if (isOnline) {
                          if (package.delivered) {
                            cellExpanded = false;
                            cellHeight = 150;
                            await _db.setPackageWaiting(package: package);
                          } else {
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
                            }, onConfirm: (date) async {
                              await connectionStatus.checkConnection();
                              if (isOnline) {
                                print('confirm $date');
                                cellExpanded = false;
                                cellHeight = 150;
                                arrivedAt = date;
                                package.arrivedAt = arrivedAt.toString();
                                await _db.setPackageDelivered(package: package);
                                setState(() {});
                              }
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          }
                        }
                      },
                      child: Text("Set Delivered"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(MyThemes.buttonColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return SizedBox();
      }
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        height: cellHeight,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (cellExpanded) {
                cellHeight = 150;
                cellExpanded = false;
                return;
              } else {
                cellHeight = 300;
                cellExpanded = true;
                return;
              }
            });
          },
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
              color: MyThemes.backgroundColorAlt,
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isDelivered(),
                      isCellExpanded(),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
