class UserModel  {

  final String uid;

  UserModel({ required this.uid});

}

class UserData  {

  final String uid;
  final String username;
  final List<String> friendList;
  final List<String> friendRequestList;
  final List<String> sentRequestList;

  UserData({ required this.uid, this.username = "", this.friendList = const [""],this.friendRequestList = const [""],this.sentRequestList = const [""],});

}
