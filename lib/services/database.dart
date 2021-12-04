import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/models/package.dart';
import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/screens/wrapper.dart';

class DatabaseService {


  UserData userData= UserData(uid: "");
  final String uid;
  DatabaseService({ this.uid = "" });




  // collection reference
  final CollectionReference UserListCollection = FirebaseFirestore.instance.collection("UserList");
  final CollectionReference UserDataCollection = FirebaseFirestore.instance.collection("UserData");


  Stream<UserData> get userInfo {
    return UserListCollection.doc(uid).snapshots()
        .map(userDataFromSnapshot);
  }

  Future createUserListRecord(String name, String email) async {
    return await UserListCollection.doc(uid).set({
      "uid": uid,
      "username": name,
      "email": email,
      "friendList": <String> [],
      "friendRequestList": <String> [],
      "sentRequestList": <String> [],
    });
  }

  Future<UserData> getUserListRecord({required String userID}) async {
    return await UserListCollection.doc(userID).get().then((snapshot) {
      return userDataFromSnapshot(snapshot);
    });
  }

  Future<List<UserData>> findUserByEmail(String email) async {



    var result = await UserListCollection.where("email", isEqualTo: email)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) {
        var docData = doc.data() as Map<String, dynamic>;

        var friendListResult = [""];
        var friendListTest = docData["friendList"];
        if(friendListTest != null) {
          friendListResult = (docData["friendList"] as List).map((item) => item as String).toList();
        }

        var friendRequestListResult = [""];
        var friendRequestListTest = docData["friendRequestList"];
        if(friendRequestListTest != null) {
          friendRequestListResult = (docData["friendRequestList"] as List).map((item) => item as String).toList();
        }

        var sentRequestListResult = [""];
        var sentRequestListTest = docData["sentRequestList"];
        if(sentRequestListTest != null) {
          sentRequestListResult = (docData["sentRequestList"] as List).map((item) => item as String).toList();
        }


        return UserData(
          uid: docData["uid"],
          username: docData["username"],
          friendList: friendListResult,
          friendRequestList: friendRequestListResult,
          sentRequestList: sentRequestListResult,
        );
      }).toList();
    });
    return result;
  }


  //userData from snapshot
  UserData userDataFromSnapshot(DocumentSnapshot snapshot) {

      var docData = snapshot.data() as Map<String, dynamic>;

      var friendListResult = [""];
      var friendListTest = docData["friendList"];
      if(friendListTest != null) {
        friendListResult = (docData["friendList"] as List).map((item) => item as String).toList();
      }

      var friendRequestListResult = [""];
      var friendRequestListTest = docData["friendRequestList"];
      if(friendRequestListTest != null) {
        friendRequestListResult = (docData["friendRequestList"] as List).map((item) => item as String).toList();
      }

      var sentRequestListResult = [""];
      var sentRequestListTest = docData["sentRequestList"];
      if(sentRequestListTest != null) {
        sentRequestListResult = (docData["sentRequestList"] as List).map((item) => item as String).toList();
      }


      return UserData(
        uid: docData["uid"],
        username: docData["username"],
        friendList: friendListResult,
        friendRequestList: friendRequestListResult,
        sentRequestList: sentRequestListResult,
      );
  }

  Future<List<UserData>> getAllUsers() async {
    var result = UserListCollection.get().then((snapshot) {
      return userListFromSnapshot(snapshot);
    });
    return result;
  }

  List<UserData> userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      var docData = doc.data() as Map<String,dynamic>;

      var friendListResult = [""];
      var friendListTest = docData["friendList"];
      if(friendListTest != null) {
        friendListResult = (docData["friendList"] as List).map((item) => item as String).toList();
      }

      var friendRequestListResult = [""];
      var friendRequestListTest = docData["friendRequestList"];
      if(friendRequestListTest != null) {
        friendRequestListResult = (docData["friendRequestList"] as List).map((item) => item as String).toList();
      }

      var sentRequestListResult = [""];
      var sentRequestListTest = docData["sentRequestList"];
      if(sentRequestListTest != null) {
        sentRequestListResult = (docData["sentRequestList"] as List).map((item) => item as String).toList();
      }


      return UserData(
        uid: docData["uid"],
        username: docData["username"],
        friendList: friendListResult,
        friendRequestList: friendRequestListResult,
        sentRequestList: sentRequestListResult,
      );


    }).toList();
  }

  Future updateUsersFriends({required List<String> friendList, required String targetid}) async {
    return await UserListCollection.doc(targetid).update({
      "friendList": friendList,
    });
  }

  Future updateUsersFriendRequests({required List<String> friendRequestList, required String targetid}) async {
    return await UserListCollection.doc(targetid).update({
      "friendRequestList": friendRequestList,
    });
  }

  Future updateUsersSentRequests({required List<String> sentRequestList, required String targetid}) async {
    return await UserListCollection.doc(targetid).update({
      "sentRequestList": sentRequestList,
    });
  }

  Future updateUsername({required String username}) async {
    await UserListCollection.doc(uid).update({
      "username": username,
    });
    var collection = UserDataCollection.doc(uid).collection("Packages");
    var querySnapshots = await collection.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({
        'user': username,
      });
    }
  }





  List<Package> packageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      var docData = doc.data() as Map<String,dynamic>;
      return Package(
        id: doc.reference.id,
        name: docData["name"] ?? "New Package",
        estimatedAt: docData["estimatedAt"] ?? DateTime.now().toString(),
        arrivedAt: docData["arrivedAt"] ?? DateTime.now().toString(),
        deliveredBy: docData["deliveredBy"] ?? "",
        address: docData["address"] ?? "",
        paymentMethod: docData["paymentMethod"] ?? "",
        delivered: docData["delivered"] ?? false,
        user: docData["user"] ?? "",
        ownerID: docData["ownerID"] ?? "",
      );
    }).toList();
  }

  Future insertPackage({required Package package}) async {
    userData = await getUserListRecord(userID: uid);
    return await UserDataCollection.doc(uid).collection("Packages").add({
      "name": package.name,
      "estimatedAt": package.estimatedAt,
      "arrivedAt": package.arrivedAt,
      "deliveredBy": package.deliveredBy,
      "address": package.address,
      "paymentMethod": package.paymentMethod,
      "delivered": package.delivered,
      "user": userData.username,
      "ownerID": userData.uid,
    });
  }

  Future updatePackage({required Package package}) async {
    return await UserDataCollection.doc(package.ownerID).collection("Packages").doc(package.id).update({
      "name": package.name,
      "estimatedAt": package.estimatedAt,
      "arrivedAt": package.arrivedAt,
      "deliveredBy": package.deliveredBy,
      "address": package.address,
      "paymentMethod": package.paymentMethod,
      "delivered": package.delivered,
    });
  }

  Future setPackageDelivered({required Package package}) async {
    return await UserDataCollection.doc(package.ownerID).collection("Packages").doc(package.id).update({
      "delivered": true,
      "arrivedAt": package.arrivedAt,
    });
  }

  Future setPackageWaiting({required Package package}) async {
    return await UserDataCollection.doc(package.ownerID).collection("Packages").doc(package.id).update({
      "delivered": false,
      "arrivedAt": DateTime.now().toString(),
    });
  }

  Future deletePackage({required Package package}) async {
    return await UserDataCollection.doc(package.ownerID).collection("Packages").doc(package.id).delete();
  }



}