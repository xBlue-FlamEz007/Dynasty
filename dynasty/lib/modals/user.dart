class USER {
  USER({this.uid});
  final String uid;
}

class UserData {
  UserData({ this.uid, this.firstName, this.lastName, this.email, this.profilePic });
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String profilePic;
}