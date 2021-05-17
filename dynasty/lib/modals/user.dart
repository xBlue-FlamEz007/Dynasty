class USER {
  USER({this.uid});
  final String uid;
}

class UserData {
  UserData({ this.uid, this.firstName, this.lastName, this.email, this.profilePic, this.phoneNumber, this.favourites });
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String profilePic;
  final String phoneNumber;
  final List <String>favourites;
}