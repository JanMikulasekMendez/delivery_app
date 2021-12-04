import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/screens/wrapper.dart';
import 'package:deliveryapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:deliveryapp/shared/constants.dart';
import 'package:provider/provider.dart';

class FriendCell extends StatefulWidget {
  FriendCell({Key? key, required this.user}) : super(key: key);
  UserData user;

  @override
  _FriendCellState createState() => _FriendCellState();
}

class _FriendCellState extends State<FriendCell> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context, listen: false);
    final DatabaseService _db = DatabaseService(uid: user!.uid);
    var cellUser = widget.user;

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
          height: 100,
          child: GestureDetector(
            onTap: () {
              print("tapped");
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                                backgroundColor: MyThemes.navbarColor,
                                radius: 20,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: MyThemes.buttonColor,
                                )),
                            Expanded(
                                child: Text(
                              cellUser.username,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: MyTextSize.medium),
                            )),
                            GestureDetector(
                              onDoubleTap: () async {
                                isOnline =
                                    await connectionStatus.checkConnection();
                                if (isOnline) {
                                  var updatedList = globalUser!.friendList;
                                  updatedList.removeWhere(
                                      (String) => String == cellUser.uid);
                                  await _db.updateUsersFriends(
                                      friendList: updatedList,
                                      targetid: globalAuthUser!.uid);

                                  cellUser = await _db.getUserListRecord(
                                      userID: cellUser.uid);
                                  var updatedOtherList = cellUser.friendList;
                                  updatedOtherList.removeWhere((String) =>
                                      String == globalAuthUser!.uid);
                                  await _db.updateUsersFriends(
                                      friendList: updatedOtherList,
                                      targetid: cellUser.uid);
                                }
                              },
                              child: CircleAvatar(
                                  backgroundColor: MyThemes.buttonColor,
                                  radius: 20,
                                  child: Icon(
                                    Icons.clear,
                                    size: 30,
                                    color: MyThemes.errorColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          )),
    );
  }
}
