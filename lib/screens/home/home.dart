import 'dart:async';

import 'package:deliveryapp/models/package.dart';
import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/screens/contacts/contacts.dart';
import 'package:deliveryapp/screens/home/package_form.dart';
import 'package:deliveryapp/screens/home/package_list.dart';
import 'package:deliveryapp/screens/home/package_screen/package_screen.dart';
import 'package:deliveryapp/screens/wrapper.dart';
import 'package:deliveryapp/services/auth.dart';
import 'package:deliveryapp/shared/constants.dart';
import 'package:deliveryapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:deliveryapp/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map myMap = {};

  List<Package> packages = [];
  List<Package> myPackages = [];
  List<Package> otherPackages = [];
  List<UserData> allUsers = [];
  List<String> userFriendlist = [];

  var StreamA;
  List StreamB = [];
  var StreamC;
  bool StreamALaunched = false;
  bool StreamBLaunched = false;
  bool StreamCLaunched = false;

  var gotEmptyList = false;

  void _showPackagePanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: MyThemes.backgroundColorAlt,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: PackageForm(),
          );
        });
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) async {
        // Execute callback if page is mounted
        if (mounted) {
          final user = Provider.of<UserModel?>(context, listen: false);
          final DatabaseService _db = DatabaseService(uid: user!.uid);

          await _db.UserListCollection.doc(globalAuthUser!.uid)
              .get()
              .then((snapshot) async {
            //ZDE TO BYLO
            globalUser = await _db.userDataFromSnapshot(snapshot);
          });

          void registerStreamA() {
            print("Registering A");
            StreamA = _db.UserDataCollection.doc(globalAuthUser!.uid)
                .collection("Packages")
                .snapshots()
                .listen((snapshot) {
              print("Data A");
              if (mounted) {
                setState(() {
                  print("State A");
                  myPackages.clear();
                  myPackages = _db.packageListFromSnapshot(snapshot);
                  packages = myPackages + otherPackages;
                  if (packages.isEmpty) {
                    gotEmptyList = true;
                  } else {
                    gotEmptyList = false;
                  }
                  ;
                });
              }
            });
          }

          Future registerStreamB() async {
            print("Registering B");
            await _db.UserListCollection.doc(globalAuthUser!.uid)
                .get()
                .then((snapshot) async {
              //ZDE TO BYLO
              globalUser = await _db.userDataFromSnapshot(snapshot);
            });

            if (globalUser!.friendList.isNotEmpty) {
              globalUser!.friendList.forEach((element) {
                if (element != "") {
                  StreamB.add((_db.UserDataCollection.doc(element)
                      .collection("Packages")
                      .snapshots()
                      .listen((snapshot) {
                    myMap[element] = _db.packageListFromSnapshot(snapshot);
                    print("Data B");
                    if (mounted) {
                      setState(() {
                        print("State B");
                        otherPackages.clear();
                        myMap.forEach((key, value) {
                          otherPackages += value as List<Package>;
                        });
                        packages = myPackages + otherPackages;
                        if (packages.isEmpty) {
                          gotEmptyList = true;
                        } else {
                          gotEmptyList = false;
                        }
                        ;
                      });
                    }
                  })));
                }
              });
            }
          }

          Future getStreamBData() async {
            await _db.UserListCollection.doc(globalAuthUser!.uid)
                .get()
                .then((snapshot) async {
              //ZDE TO BYLO
              globalUser = await _db.userDataFromSnapshot(snapshot);
            });

            myMap.clear();
            print("1 Map Cleared : $myMap");
            print(
                "1b Friendlist to use for new map : ${globalUser!.friendList}");
            if (globalUser!.friendList.isNotEmpty) {
              for (var element in globalUser!.friendList) {
                //await Future.delayed(const Duration(seconds: 5));
                if (element != "") {
                  await _db.UserDataCollection.doc(element)
                      .collection("Packages")
                      .get()
                      .then((snapshot) async {
                    myMap[element] =
                        await _db.packageListFromSnapshot(snapshot);
                    print("2 New Map Created with new friendlist : $myMap");
                  });
                }
              }
            }
            packages.clear();
            print("2b packages cleared : $packages");
            otherPackages.clear();
            myMap.forEach((key, value) {
              otherPackages += value as List<Package>;
            });
            packages = myPackages + otherPackages;
            if (packages.isEmpty) {
              gotEmptyList = true;
            } else {
              gotEmptyList = false;
            }
            ;
            print("2c packages created : $packages");

            print("3 Got Map list : $myMap");
            print("3b Got this many other packages : ${otherPackages.length}");
            StreamB.forEach((element) async {
              StreamSubscription sub = element as StreamSubscription;
              await element.cancel();
            });
            StreamB.clear();
            registerStreamB();
          }

          Future<void> registerStreamC() async {
            print("Registering C");
            StreamC = _db.UserListCollection.doc(globalAuthUser!.uid)
                .snapshots()
                .listen((snapshot) async {
              //ZDE TO BYLO
              //globalUser = await _db.userDataFromSnapshot(snapshot);
              print("Data C");

              await getStreamBData();
              if (mounted) {
                setState(() {
                  print("State C");
                });
              }
            });
          }

          registerStreamA();
          registerStreamB();
          registerStreamC();
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService _db = DatabaseService(uid: globalAuthUser!.uid);
    //print("Loaded username in home :" + globalUser!.username);
    //print("friendlist in home :" + globalUser!.friendList.toString());
    print("BUILDING WIDGET INIT WITH FRIENDLIST ${globalUser!.username}");
    print("BUILDING WIDGET INIT WITH FRIENDLIST ${globalUser!.friendList}");

    Widget _loader() {
      print("LOADING DATABASE");
      if (packages.isNotEmpty) {
        return SafeArea(
            child: PackageList(
          packages: packages,
        ));
      } else {
        if (gotEmptyList == false) {
          return Loading(
            loadingReason: "Loading Data...",
          );
        } else {
          return LoadingNoDataFound(
            loadingReason: "No Data Found",
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyThemes.navbarColor,
        title: Text(
          "Package List",
          style: titleStyle,
        ),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () async {
                isOnline = await connectionStatus.checkConnection();
                print(isOnline);
                if (isOnline) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PackageScreen(editmode: false)));
                }
              },
              icon:
                  Icon(Icons.archive_outlined, color: MyThemes.barButtonColor),
              label:
                  Text("New", style: TextStyle(color: MyThemes.barButtonColor)))
        ],
      ),
      body: Container(
        decoration: gradientDecoration,
        child: _loader(),
      ),
    );
  }
}
