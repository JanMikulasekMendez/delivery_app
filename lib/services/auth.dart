import 'package:firebase_auth/firebase_auth.dart';
import 'package:deliveryapp/models/user.dart';
import 'package:deliveryapp/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user obj
  UserModel? _userFromFirebaseUser(var user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }




  // auth change user stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }


  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      await DatabaseService().createUserListRecord("User1","User1@email.com");
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }



  // sign in with email & password

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      //await DatabaseService(uid: user!.uid).updateUserData("0", "Nový uživatel", 100, "Rozhoduje se", true);
      return _userFromFirebaseUser(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
}

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
}

}