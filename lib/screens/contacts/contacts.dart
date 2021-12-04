import 'dart:async';

import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/screens/contacts/friend_request_cell.dart';
import 'package:deliveryapp/screens/contacts/sent_request_cell.dart';
import 'package:deliveryapp/screens/wrapper.dart';
import 'package:deliveryapp/services/auth.dart';
import 'package:deliveryapp/services/database.dart';
import 'package:deliveryapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:provider/provider.dart';
import 'friend_cell.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String searchUser = "";

  List<UserData> userFriendlist = [];
  List<UserData> userFriendRequestlist = [];
  List<UserData> userSentRequestlist = [];

  int _currentSelection = 0;

  var StreamA = null;
  var StreamAb = null;
  var StreamAc = null;
  var StreamB = null;
  bool showUserBar = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        // Execute callback if page is mounted
        if (mounted) {
          final user = Provider.of<UserModel?>(context, listen: false);
          final DatabaseService _db = DatabaseService(uid: user!.uid);

          Future registerStreamA() async {
            print("STREAM A LAUNCHED");
            await _db.UserListCollection.doc(globalAuthUser!.uid)
                .get()
                .then((snapshot) async {
              //ZDE TO BYLO
              globalUser = await _db.userDataFromSnapshot(snapshot);
            });
            if (globalUser!.friendList.isNotEmpty) {
              StreamA = _db.UserListCollection.where("uid",
                      whereIn: globalUser!.friendList)
                  .snapshots()
                  .listen((snapshot) {
                //ZDE TO BYLO
                userFriendlist = _db.userListFromSnapshot(snapshot);
                if (mounted) {
                  print("STREAM A FUNC");
                  setState(() {
                    print("STREAM A STATE SET");
                  });
                }
              });
            }

            if (globalUser!.friendRequestList.isNotEmpty) {
              StreamAb = _db.UserListCollection.where("uid",
                      whereIn: globalUser!.friendRequestList)
                  .snapshots()
                  .listen((snapshot) {
                //ZDE TO BYLO
                userFriendRequestlist = _db.userListFromSnapshot(snapshot);
                if (mounted) {
                  print("STREAM Ab FUNC");
                  print(userFriendRequestlist);
                  setState(() {
                    print("STREAM Ab STATE SET");
                  });
                }
              });
            }

            if (globalUser!.sentRequestList.isNotEmpty) {
              StreamAc = _db.UserListCollection.where("uid",
                      whereIn: globalUser!.sentRequestList)
                  .snapshots()
                  .listen((snapshot) {
                //ZDE TO BYLO
                userSentRequestlist = _db.userListFromSnapshot(snapshot);
                if (mounted) {
                  print("STREAM Ab FUNC");
                  print(userSentRequestlist);
                  setState(() {
                    print("STREAM Ab STATE SET");
                  });
                }
              });
            }
          }

          Future _getList() async {
            await _db.UserListCollection.doc(globalAuthUser!.uid)
                .get()
                .then((snapshot) async {
              //ZDE TO BYLO
              globalUser = await _db.userDataFromSnapshot(snapshot);
            });

            print(StreamA);
            if (StreamA != null) {
              await StreamA.cancel();
            }
            ;
            if (StreamAb != null) {
              await StreamAb.cancel();
            }
            ;
            if (StreamAc != null) {
              await StreamAc.cancel();
            }
            ;

            print("USER FRIENDLIST BEFORE CALL FOR FRIEND OBJECTS:" +
                globalUser!.friendList.toString());
            if (globalUser!.friendList.isNotEmpty) {
              await _db.UserListCollection.where("uid",
                      whereIn: globalUser!.friendList)
                  .get()
                  .then((snapshot) {
                userFriendlist = _db.userListFromSnapshot(snapshot);
                print("LIST REFRESH RECIEVED WITH LENGTH :" +
                    userFriendlist.length.toString());
              });
            } else {
              userFriendlist.clear();
            }

            print("USER FRIENDREQUESTLIST BEFORE CALL FOR FRIEND OBJECTS:" +
                globalUser!.friendRequestList.toString());
            if (globalUser!.friendRequestList.isNotEmpty) {
              await _db.UserListCollection.where("uid",
                      whereIn: globalUser!.friendRequestList)
                  .get()
                  .then((snapshot) {
                userFriendRequestlist = _db.userListFromSnapshot(snapshot);
                print("LIST REFRESH RECIEVED WITH LENGTH :" +
                    userFriendRequestlist.length.toString());
              });
            } else {
              userFriendRequestlist.clear();
            }

            print("USER FRIENDREQUESTLIST BEFORE CALL FOR FRIEND OBJECTS:" +
                globalUser!.sentRequestList.toString());
            if (globalUser!.sentRequestList.isNotEmpty) {
              await _db.UserListCollection.where("uid",
                      whereIn: globalUser!.sentRequestList)
                  .get()
                  .then((snapshot) {
                userSentRequestlist = _db.userListFromSnapshot(snapshot);
                print("LIST REFRESH RECIEVED WITH LENGTH :" +
                    userSentRequestlist.length.toString());
              });
            } else {
              userSentRequestlist.clear();
            }

            registerStreamA();
          }

          Future<void> registerStreamB() async {
            print("STREAM B LAUNCHED");
            StreamB = _db.UserListCollection.doc(globalAuthUser!.uid)
                .snapshots()
                .listen((snapshot) async {
              //ZDE TO BYLO
              globalUser = await _db.userDataFromSnapshot(snapshot);
              print("USER FRIENDLIST BEFORE CALL FOR SETSTATE FROM STREAM B:" +
                  globalUser!.friendList.toString());
              if (mounted) {
                print("STREAM B FUNC");

                await _getList();

                setState(() {
                  print("STREAM B STATE SET");
                });
              }
            });
          }

          registerStreamA();
          registerStreamB();
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build init");
    final user = Provider.of<UserModel?>(context);
    final DatabaseService _db = DatabaseService(uid: user!.uid);

    Widget selectScreen() {
      print("CREATING DATA TABLE");
      //return Container();
      switch (_currentSelection) {
        case 0:
          return Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: userFriendlist.length + 1,
                  itemBuilder: (context, index) {
                    if (index == userFriendlist.length) {
                      return SizedBox(
                        height: 20,
                      );
                    } else {
                      return FriendCell(user: userFriendlist[index]);
                    }
                  }),
            ),
          );
        case 1:
          return Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: userFriendRequestlist.length + 1,
                  itemBuilder: (context, index) {
                    if (index == userFriendRequestlist.length) {
                      return SizedBox(
                        height: 20,
                      );
                    } else {
                      return FriendRequestCell(
                          user: userFriendRequestlist[index]);
                    }
                  }),
            ),
          );
        case 2:
          return Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: userSentRequestlist.length + 1,
                  itemBuilder: (context, index) {
                    if (index == userSentRequestlist.length) {
                      return SizedBox(
                        height: 20,
                      );
                    } else {
                      return SentRequestCell(user: userSentRequestlist[index]);
                    }
                  }),
            ),
          );
        default:
          return Container();
      }
    }

    Future<void> _showRequestAlert(String title, String text) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: MyThemes.backgroundColorAlt,
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(text)],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
                style: ElevatedButton.styleFrom(primary: MyThemes.buttonColor),
              ),
            ],
          );
        },
      );
    }

    Widget topBar() {
      return TextButton.icon(
          onPressed: () async {
            setState(() {
              showUserBar = !showUserBar;
            });
          },
          icon: Icon(Icons.search, color: MyThemes.barButtonColor),
          label: Text("Add", style: TextStyle(color: MyThemes.barButtonColor)));
    }

    Widget friendSearchBar() {
      if (showUserBar) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: TextFormField(
                decoration: textInputDecoration2.copyWith(
                    labelText: "Enter users email"),
                onChanged: (val) {
                  searchUser = val;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                      onPressed: () async {
                        await connectionStatus.checkConnection();
                        if (isOnline) {
                          List<UserData> foundUsers =
                              await _db.findUserByEmail(searchUser);
                          if (foundUsers.isEmpty) {
                            _showRequestAlert("Error!", "Recipient not found");
                          } else {
                            var friendList = globalUser!.friendList;
                            var requestList = globalUser!.friendRequestList;
                            var sentRequestList = globalUser!.sentRequestList;
                            var targetRequestList =
                                foundUsers[0].friendRequestList;
                            print(
                                "target req name : ${foundUsers[0].username}");
                            print("target req list : $targetRequestList");
                            if (friendList.contains(foundUsers[0].uid) ==
                                false) {
                              if (requestList.contains(foundUsers[0].uid) ==
                                  false) {
                                if (foundUsers[0].uid != globalUser!.uid &&
                                    targetRequestList
                                            .contains(globalUser!.uid) ==
                                        false) {
                                  if (targetRequestList.isEmpty) {
                                    targetRequestList = [globalUser!.uid];
                                  } else {
                                    targetRequestList.add(globalUser!.uid);
                                  }
                                  if (sentRequestList.isEmpty) {
                                    sentRequestList = [foundUsers[0].uid];
                                  } else {
                                    sentRequestList.add(foundUsers[0].uid);
                                  }
                                  _showRequestAlert("Success!",
                                      "Friend request has been sent");
                                  await _db.updateUsersFriendRequests(
                                      friendRequestList: targetRequestList,
                                      targetid: foundUsers[0].uid);
                                  await _db.updateUsersSentRequests(
                                      sentRequestList: sentRequestList,
                                      targetid: globalUser!.uid);
                                } else {
                                  _showRequestAlert("Error!",
                                      "Friend request has been already sent");
                                }
                              } else {
                                _showRequestAlert("Error!",
                                    "You already have pending request from this user");
                              }
                            } else {
                              _showRequestAlert("Error!",
                                  "This user is already in your friend list!");
                            }
                          }
                        }
                      },
                      icon: Icon(Icons.person_add,
                          color: MyThemes.barButtonColor),
                      label: Text("Invite",
                          style: TextStyle(color: MyThemes.barButtonColor))),
                ],
              ),
            ),
          ],
        );
      } else {
        return SizedBox();
      }
    }

    Map<int, Widget> _children = {
      0: Text(
        'Friends ${userFriendlist.length}',
        textAlign: TextAlign.center,
      ),
      1: Text(
        'Requests ${userFriendRequestlist.length}',
        textAlign: TextAlign.center,
      ),
      2: Text(
        'Awaiting Response ${userSentRequestlist.length}',
        textAlign: TextAlign.center,
      ),
    };

    //print (user!.username);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Contacts",
            style: titleStyle,
          ),
          leading: TextButton.icon(
              onPressed: () async {
                await AuthService().signOut();
              },
              icon: Icon(Icons.person_outline, color: MyThemes.barButtonColor),
              label: Text("Logout",
                  style: TextStyle(color: MyThemes.barButtonColor))),
          leadingWidth: 110,
          backgroundColor: MyThemes.navbarColor,
          actions: [
            topBar(),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          decoration: gradientDecoration,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                friendSearchBar(),
                SizedBox(height: 20),
                MaterialSegmentedControl(
                  children: _children,
                  selectionIndex: _currentSelection,
                  borderColor: Colors.grey,
                  selectedColor: MyThemes.backgroundColorAlt!,
                  unselectedColor: MyThemes.navbarColor!,
                  borderRadius: 8.0,
                  //disabledChildren: _disabledIndices,
                  onSegmentChosen: (index) {
                    setState(() {
                      _currentSelection = index as int;
                    });
                  },
                ),
                selectScreen(),
              ],
            ),
          ),
        ));
  }
}

/*
  TextButton.icon(
                          onPressed: () async {

                            List<UserData> foundUsers = await _db.findUserByEmail(searchUser);
                            if(foundUsers.isEmpty){
                              _showRequestFailedUserNotFound();
                            }
                            else{
                              var friendList = globalUser!.friendList;
                              var targetRequestList = foundUsers[0].friendRequestList;
                              if(foundUsers[0].uid != user.uid && friendList.contains(foundUsers[0].uid) == false){
                                if(friendList.isEmpty){
                                  friendList = [foundUsers[0].uid];
                                }
                                else {
                                  friendList.add(foundUsers[0].uid);
                                }
                                _showRequestSent();
                                await _db.updateUsersFriends(friendList: friendList, targetid: user.uid);
                              }
                              else{
                                _showRequestFailedUserAlreadyInList();
                              }
                            }
                          },
 */
